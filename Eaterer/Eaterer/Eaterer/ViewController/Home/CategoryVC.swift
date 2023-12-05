

import UIKit
import HealthKit
import SDWebImage

class CategoryVC: UIViewController {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryDecription: UITextView!
    @IBOutlet weak var ingredientTV: UITextView!
    @IBOutlet weak var caloriesTV: UILabel!
    var category : CategoryModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryImage.sd_setImage(with: category.foodImage.encodedURL().toURL() ?? defaultURlImage.encodedURL().toURL()!, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            self.categoryImage.image =  image
        })

        self.categoryDecription.text = category.description
        self.ingredientTV.text = category.ingredients

                
        HealthKitManager.shared.requestAuthorization { success, err in
            if success{
                self.queryDietaryEnergyConsumed(forFood: self.category.title) { (totalDietaryEnergy, error) in
                    if let error = error {
                        print("Error querying dietary energy: \(error)")
                    } else {
                        if let totalDietaryEnergy = totalDietaryEnergy {
                            DispatchQueue.main.async {
                                self.caloriesTV.text = "\(totalDietaryEnergy) calories"
                                if totalDietaryEnergy == 0.0 {
                                    self.caloriesTV.text = "\(self.category.Calories) calories"
                                }
                            }
                        } else {
                            print("No dietary energy data found for Pizza")
                        }
                    }
                }
            } else {
                print("Healthkit authorization issue")
            }
        }
    }
    
    func queryDietaryEnergyConsumed(forFood foodDescription: String, completion: @escaping (Double?, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "edu.nwmissouri.edu.eaterer", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device."]))
            return
        }

        let dietaryEnergyType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!

        let predicate = HKQuery.predicateForObjects(from: HKSource.default())

        let query = HKSampleQuery(sampleType: dietaryEnergyType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            // Filter samples for the specified food description
            let filteredSamples = (samples as? [HKQuantitySample])?.filter { sample in
                return sample.metadata?[HKMetadataKeyFoodType] as? String == foodDescription
            }

            let totalDietaryEnergy = filteredSamples?.reduce(0.0) { (result, sample) in
                return result + sample.quantity.doubleValue(for: .kilocalorie())
            }

            completion(totalDietaryEnergy, nil)
        }

        let healthStore = HKHealthStore()
        healthStore.execute(query)
    }

}
