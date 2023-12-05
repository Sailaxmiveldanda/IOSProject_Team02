import Foundation

class RestaurantAPI {
    static let shared = RestaurantAPI()
    private let baseURL = URL(string: "https://7f2df80e9b2c44c0b4eb0c974b5d065a.api.mockbin.io/")!

    func getAllRestaurants(completion: @escaping (Result<RestaurantList, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("your-endpoint-here")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "app.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }

            do {
                let decoder = JSONDecoder()
                let restaurantList = try decoder.decode(RestaurantList.self, from: data)
                print(restaurantList)
                DispatchQueue.main.async {
                    completion(.success(restaurantList))
                }
              
            } catch {
                    completion(.failure(error))
            }
        }.resume()
    }
}

 
