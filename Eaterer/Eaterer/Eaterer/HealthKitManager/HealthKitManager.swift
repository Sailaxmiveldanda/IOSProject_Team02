//
//  HealthKitManager.swift
//  Eaterer
//
//  Created by Macbook-Pro on 07/11/23.
//

import Foundation
import HealthKit
import UIKit

class HealthKitManager {
    
    static let shared = HealthKitManager()
    
    private init() {}
    

    let healthStore = HKHealthStore()

    func requestHealthKitAuthorization() {
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!

        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: [], read: [stepCountType]) { (success, error) in
                if success {
                    // Authorization granted
//                    self.queryHealthData()
                } else {
                    // Handle the error and show an informative message to the user
                    if let error = error {
                        print("HealthKit authorization failed with error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
           guard HKHealthStore.isHealthDataAvailable() else {
               print("Health data is not available on this device.")
               completion(false, nil)
               return
           }

           let dietaryEnergyConsumedType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!

           healthStore.requestAuthorization(toShare: nil, read: [dietaryEnergyConsumedType]) { (success, error) in
               completion(success, error)
           }
       }
}
