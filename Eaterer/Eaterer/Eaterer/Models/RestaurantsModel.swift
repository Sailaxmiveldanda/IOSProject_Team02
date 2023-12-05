import Foundation
import FirebaseFirestoreSwift

//struct RestaurantsModel: Codable {
//    var rating, image, location,name,countryAndPin, time: String
//    var haveOffer :Bool
//    var id : Int
//    var bookingAmount : Int
//}

struct RestaurantsModel: Codable {
    let image: String
    let name: String
    let haveOffer: Bool
    let bookingAmount: Int
    let location: String
    let countryAndPin: String
    let time: String
    let rating: String
    let id: Int
}

struct RestaurantList: Codable {
    let restaurants: [RestaurantsModel]
}
