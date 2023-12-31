
import UIKit
import FirebaseCore
import HealthKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var healthStore : HKHealthStore?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let healthStore = HKHealthStore()

        if HKHealthStore.isHealthDataAvailable() {
            let readTypes: Set<HKObjectType> = [
                HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
            ]

            healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
                if success {
                } else {
                }
            }
        } else {
        }

        UINavigationBar.appearance().tintColor = .black

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

