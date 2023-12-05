 
import UIKit

class ViewModel {

    static let shared = ViewModel()
    
 
    func getCategories(completion: @escaping ([CategoryModel])->()) {
  
        FireStoreManager.shared.getAllCategories { list in
            
            completion(list)
        }
    }
    
    func getAllOffers(completion: @escaping ([OffersModel])->()) {
  
        FireStoreManager.shared.getAllOffers { list in
            completion(list)
        }
    }

    
    func getAllRestaurants(completion: @escaping ([RestaurantsModel])->()) {
  
        
        RestaurantAPI.shared.getAllRestaurants { result in
            switch result {
            case .success(let restaurantList):
                print("Fetched restaurants: \(restaurantList.restaurants)")
                completion(restaurantList.restaurants)
            case .failure(let error):
                print("Error fetching restaurants: \(error)")
            }
        }

        
//
//        FireStoreManager.shared.getAllRestaurants { result in
//            switch result {
//            case .success(let restaurantList):
//
//                completion(restaurantList)
//            case .failure(let error):
//                print("Error fetching restaurant data: \(error)")
//            }
//        }
         
    }
}
