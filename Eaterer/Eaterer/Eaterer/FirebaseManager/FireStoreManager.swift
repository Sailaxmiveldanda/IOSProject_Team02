
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift


class FireStoreManager {
   
   public static let shared = FireStoreManager()
   var hospital = [String]()

   var db: Firestore!
   var dbRef : CollectionReference!
   var prescription : CollectionReference!
   var lastMessages : CollectionReference!
   var chatDbRef : CollectionReference!
   
   init() {
       let settings = FirestoreSettings()
       Firestore.firestore().settings = settings
       db = Firestore.firestore()
       dbRef = db.collection("Users")
   }
   
   func signUp(username:String,name:String,email:String,phone:String,password:String) {
       
       self.checkAlreadyExistAndSignup(username:username,name:name,email:email,phone:phone,password:password)
   }

    func deleteAccount(email: String, completion: @escaping (Error?) -> Void) {
        
         let userQuery = dbRef.whereField("email", isEqualTo: email)
        
         userQuery.getDocuments { (snapshot, error) in
            if let error = error {
                // Handle the error
                completion(error)
            } else {
                // Check if there are any documents with the given email
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    let noUserError = NSError(domain: "App", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                    completion(noUserError)
                    return
                }
                
                // Assuming there is only one user with a unique email, if not, you may need to handle it accordingly
                if let userDocument = documents.first {
                    // Delete the user document
                    userDocument.reference.delete { error in
                        if let error = error {
                            // Handle the error
                            completion(error)
                        } else {
                            // Successfully deleted the user document
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

   
   func login(username:String,password:String,completion: @escaping (Bool)->()) {
       let  query = db.collection("Users").whereField("username", isEqualTo: username)
       
       query.getDocuments { (querySnapshot, err) in
        
           if(querySnapshot?.count == 0) {
               showAlerOnTop(message: "username not found!!")
           }else {

               for document in querySnapshot!.documents {
                   print("doclogin = \(document.documentID)")
                   UserDefaults.standard.setValue("\(document.documentID)", forKey: "documentId")

                   if let pwd = document.data()["password"] as? String{

                       if(pwd == password) {

                           let name = document.data()["name"] as? String ?? ""
                           let username = document.data()["username"] as? String ?? ""
                           let phone = document.data()["phone"] as? String ?? ""
                           let email = document.data()["email"] as? String ?? ""
                           let password = document.data()["password"] as? String ?? ""
                           
                           UserDefaultsManager.shared.saveData(name: name, username: username, phone: phone, email: email, password: password)
                           completion(true)

                       }else {
                           showAlerOnTop(message: "Password doesn't match")
                       }


                   }else {
                       showAlerOnTop(message: "Something went wrong!!")
                   }
               }
           }
       }
  }
       
   func getPassword(email:String,password:String,completion: @escaping (String)->()) {
       let  query = db.collection("Users").whereField("email", isEqualTo: email)
       
       query.getDocuments { (querySnapshot, err) in
        
           if(querySnapshot?.count == 0) {
               showAlerOnTop(message: "Email id not found!!")
           }else {

               for document in querySnapshot!.documents {
                   print("doclogin = \(document.documentID)")
                   UserDefaults.standard.setValue("\(document.documentID)", forKey: "documentId")
                   if let pwd = document.data()["password"] as? String{
                           completion(pwd)
                   }else {
                       showAlerOnTop(message: "Something went wrong!!")
                   }
               }
           }
       }
  }
   
   func checkAlreadyExistAndSignup(username:String,name:String,email:String,phone:String,password:String) {
       
       getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
            
           print(querySnapshot.count)
           
           if(querySnapshot.count > 0) {
               showAlerOnTop(message: "This Email is Already Registerd!!")
           }else {
               
               // Signup
               
               let data = ["username":username,"name":name,"phone":phone,"email":email,"password":password] as [String : Any]
               
               self.addDataToFireStore(data: data) { _ in
                   
                 
                   showOkAlertAnyWhereWithCallBack(message: "Registration Success!!") {
                        
                       DispatchQueue.main.async {
                           SceneDelegate.shared?.loginCheckOrRestart()
                       }
                      
                   }
                   
               }
              
           }
       }
   }
   
   func getQueryFromFirestore(field:String,compareValue:String,completionHandler:@escaping (QuerySnapshot) -> Void){
       
       dbRef.whereField(field, isEqualTo: compareValue).getDocuments { querySnapshot, err in
           
           if let err = err {
               
               showAlerOnTop(message: "Error getting documents: \(err)")
                           return
           }else {
               
               if let querySnapshot = querySnapshot {
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
       }
       
   }
   
   func addDataToFireStore(data:[String:Any] ,completionHandler:@escaping (Any) -> Void){
       let dbr = db.collection("Users")
       dbr.addDocument(data: data) { err in
                  if let err = err {
                      showAlerOnTop(message: "Error adding document: \(err)")
                  } else {
                      completionHandler("success")
                  }
    }
       
       
   }
}

extension FireStoreManager {
    
    
    func getAllCategories(completion: @escaping ([CategoryModel])->()) {
       
        db.collection("Category").getDocuments { (querySnapshot, err) in
            
             if let err = err {
                    print("Error getting documents: \(err)")
                    completion([])
                } else {
                    var list: [CategoryModel] = []
                    for document in querySnapshot!.documents {
                        do {
                            let temp = try document.data(as: CategoryModel.self)
                            list.append(temp)
                        }catch let error {
                            print(error)
                        }
                    }
                    completion( list)
                }
            }
    }
    
    
    func getAllOffers(completion: @escaping ([OffersModel])->()) {
       
        db.collection("Offers").getDocuments { (querySnapshot, err) in
            
             if let err = err {
                    print("Error getting documents: \(err)")
                    completion([])
                } else {
                    var list: [OffersModel] = []
                    for document in querySnapshot!.documents {
                        do {
                            let temp = try document.data(as: OffersModel.self)
                            list.append(temp)
                        }catch let error {
                            print(error)
                        }
                    }
                    completion( list)
                }
            }
    }
    
    
    func getAllRestaurants(completion: @escaping (Result<RestaurantList, Error>) -> Void) {
        guard let url = URL(string: "https://a90affaee54d4d69a45d925a21f13739.api.mockbin.io/") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(RestaurantList.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

//
//     func getAllRestaurants(completion: @escaping ([RestaurantList])->()) {
//
//        db.collection("Restaurants").getDocuments { (querySnapshot, err) in
//
//
//             if let err = err {
//                    print("Error getting documents: \(err)")
//                    completion([])
//                } else {
//                    var list: [Restaurant] = []
//                    for document in querySnapshot!.documents {
//                        do {
//                            print(document.data())
//                            let temp = try document.data( RestaurantList.self)
//                            list.append(temp)
//                        }catch let error {
//                            print(error)
//                        }
//                    }
//                    completion( list)
//                }
//            }
//    }
    
    func updateProfile(documentid:String, userData: [String:String] ,completion: @escaping (Bool)->()) {
        let  query = db.collection("Users").document(documentid)
        
        query.updateData(userData) { error in
            if let error = error {
                print("Error updating Firestore data: \(error.localizedDescription)")
                // Handle the error
            } else {
                print("Profile data updated successfully")
                completion(true)
                // Handle the success
            }
        }
    }
}
