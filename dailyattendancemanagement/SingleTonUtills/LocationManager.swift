import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func request() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.monitoredRegions
    }
    
    func start()  {
        locationManager.startUpdatingLocation()
    }

    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            var stringValue:String {
                guard let status = locationStatus else {
                    return "unknown"
                }

                switch status {
                case .notDetermined: return "notDetermined"
                case .authorizedWhenInUse: return "authorizedWhenInUse"
                case .authorizedAlways: return "authorizedAlways"
                case .restricted: return "restricted"
                case .denied: return "denied"
                default: return "unknown"
                }
            }
            statusString = stringValue
            
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var statusString:String = "" {
        willSet {
            objectWillChange.send()
        }
    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        LocationModel.create(location: location)
        print(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion \(region)")
    }
}
