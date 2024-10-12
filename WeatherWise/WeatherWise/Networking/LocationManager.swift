import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var locationError: String?

    override init() {
        super.init()
        manager.delegate = self
        checkAuthorizationStatus()
    }

    func checkAuthorizationStatus() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async {
                self.requestLocation()
            }
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.locationError = "Location access denied or restricted."
            }
        default:
            break
        }
    }

    func requestLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            DispatchQueue.main.async {
                self.locationError = "Location services are not enabled."
            }
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
        }
        manager.requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.locationError = "Location access denied or restricted."
            }
        case .notDetermined:
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.location = locations.first?.coordinate
            self.isLoading = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = "Error getting location: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
