import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        registerDefaults()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
            if authorized {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        })
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

private extension AppDelegate {
    private func registerDefaults() {
        do {
            let settingsFile = Bundle.main.url(forResource: "Settings", withExtension: "bundle")
            let settingsData = try Data(contentsOf: settingsFile!.appendingPathComponent("Root.plist"))
            let settingsPlist = try PropertyListSerialization.propertyList(
                from: settingsData,
                options: [],
                format: nil) as? [String: Any]
            let settingsPreferences = settingsPlist?["PreferenceSpecifiers"] as? [[String: Any]]
            var defaultsToRegister = [String: Any]()
            settingsPreferences?.forEach { preference in
                if let key = preference["Key"] as? String {
                    defaultsToRegister[key] = preference["DefaultValue"]
                }
            }
            appDefaults.register(defaults: defaultsToRegister)
        } catch {
            return
        }
    }
}
