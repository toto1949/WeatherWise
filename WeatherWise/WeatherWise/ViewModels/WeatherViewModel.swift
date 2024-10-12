//
//  WeatherViewModel.swift
//  WeatherWise
//
//  Created by Taoufiq El Moutaouakil on 10/8/24.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: ObservableObject {
    private var locationManager: LocationManager
    private var weatherManager: WeatherManager
    private var cancellables = Set<AnyCancellable>()

    @Published var currentWeather: WeatherResponseBody?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var searchText = ""
    private var debouncedSearchText = PassthroughSubject<String, Never>()

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.weatherManager = WeatherManager()
        fetchLocationWeather()
        observeSearchText()
    }
    
   
    func fetchLocationWeather() {
        locationManager.$location
            .compactMap { $0 }
            .flatMap { [unowned self] location -> AnyPublisher<WeatherResponseBody, Error> in
                self.isLoading = true
                return self.fetchWeather(for: location)
                    .handleEvents(receiveCompletion: { _ in
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { weatherResponse in
                if self.searchText.isEmpty {
                    self.currentWeather = weatherResponse
                }
            })
            .store(in: &cancellables)
    
    }
    private func observeSearchText() {
        $searchText
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main) 
            .sink { [weak self] searchText in
                guard let self = self else { return }
                if searchText.isEmpty {
                    self.fetchLocationWeather()
                } else {
                    self.fetchWeatherForCity(cityName: searchText)
                }
            }
            .store(in: &cancellables)

    }

    private func fetchWeather(for location: CLLocationCoordinate2D) -> AnyPublisher<WeatherResponseBody, Error> {
        return Future { promise in
            Task {
                do {
                    let weather = try await self.weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                    DispatchQueue.main.async {
                        promise(.success(weather))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error)) 
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchWeatherForCity(cityName: String) {
        guard !cityName.isEmpty else { return }
        
        let components = cityName.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        let query: String
        
        switch components.count {
        case 1:
            query = "\(components[0]),US"
        case 2:
            query = "\(components[0]),\(components[1])"
        case 3:
            query = "\(components[0]),\(components[1]),\(components[2])"
        default:
            return  
        }
        
        isLoading = true
        
        Task {
            do {
                let weather = try await weatherManager.getCurrentWeather(for: query)
                DispatchQueue.main.async {
                    self.currentWeather = weather
                    self.errorMessage = nil
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }



}
