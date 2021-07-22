import Foundation

let appDefaults = UserDefaults(suiteName: "group.cloud.tavitian.fallacious") ?? .standard

extension UserDefaults {
    @objc dynamic var animations: Bool {
        get {
            return bool(forKey: "animations")
        }
        set {
            set(newValue, forKey: "animations")
        }
    }
    
    var appVersion: String {
        get {
            return string(forKey: "appVersion") ?? "Unknown"
        }
    }
    
    var appBuild: String {
        get {
            return string(forKey: "appBuild") ?? "Unknown"
        }
    }
}
