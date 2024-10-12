//
//  WeatherViewModelTests.swift
//  WeatherWiseTests
//
//  Created by Taooufiq El moutaoouakil on 10/11/24.
//
import XCTest
import Combine
import CoreLocation
@testable import WeatherWise // Replace with your actual app module name

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockLocationManager: LocationManager!
    var mockWeatherManager: MockWeatherManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockLocationManager = LocationManager() // Initialize your LocationManager
        mockWeatherManager = MockWeatherManager()
        viewModel = WeatherViewModel(locationManager: mockLocationManager)
        viewModel.weatherManager = mockWeatherManager // Inject the mock weather manager
    }

    override func tearDown() {
        viewModel = nil
        mockLocationManager = nil
        mockWeatherManager = nil
        cancellables = []
        super.tearDown()
    }

    func testFetchWeatherSuccess() async {
        // Given
        let expectedWeatherResponse = WeatherResponseBody(
            cod: "200",
            message: 0,
            cnt: 1,
            list: [],
            city: CityResponse(
                name: "Test City",
                country: "US",
                coord: CoordinateResponse(lat: 0.0, lon: 0.0),
                population: 0,
                timezone: 0,
                sunrise: 0,
                sunset: 0
            )
        )
        mockWeatherManager.weatherResponse = expectedWeatherResponse
        
        // When
        await viewModel.fetchWeather(for: CLLocationCoordinate2D(latitude: 0, longitude: 0))

        // Then
        XCTAssertEqual(viewModel.currentWeather, expectedWeatherResponse)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testFetchWeatherError() async {
        // Given
        let expectedError = NSError(domain: "WeatherError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Weather fetch error"])
        mockWeatherManager.error = expectedError
        
        // When
        await viewModel.fetchWeather(for: CLLocationCoordinate2D(latitude: 0, longitude: 0))

        // Then
        XCTAssertNil(viewModel.currentWeather)
        XCTAssertEqual(viewModel.errorMessage, expectedError.localizedDescription)
        XCTAssertFalse(viewModel.isLoading)
    }
}
