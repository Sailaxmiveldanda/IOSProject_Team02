
import UIKit
import SDWebImage

class OffersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    var allRestaurants:[RestaurantsModel] = []
    var imageUrl = ""
    @IBOutlet weak var offerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        self.offerImage.sd_setImage(with: imageUrl.encodedURL().toURL() ?? defaultURlImage.encodedURL().toURL()!, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            self.offerImage.image =  image
        })
    }
    

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allRestaurants.count
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let restaurant = allRestaurants[indexPath.row]
        cell.restoImage.sd_setImage(with: restaurant.image.encodedURL().toURL() ?? defaultURlImage.encodedURL().toURL()!, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            cell.restoImage.image =  image
        })
        cell.restoName?.text = restaurant.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "RestaurantDetailVC" ) as! RestaurantDetailVC
        vc.restaurant = self.allRestaurants[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}
