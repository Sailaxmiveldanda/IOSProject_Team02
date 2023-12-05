 
import UIKit
import SDWebImage

class
RestaurantDetailVC: UIViewController {
    @IBOutlet weak var location: UILabel?
    @IBOutlet weak var timing: UILabel?
    @IBOutlet weak var rating: UILabel?

    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var resName: UILabel!
    var restaurant : RestaurantsModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location?.text = "Location: \(restaurant.location)"
        self.timing?.text = "Timing: \(restaurant.time)"
        self.rating?.text = "Rating: \(restaurant.rating)"
        self.resName.text = restaurant.name
        resImage.sd_setImage(with: restaurant.image.encodedURL().toURL() ?? defaultURlImage.encodedURL().toURL()!, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in

        })
        
    }
    
 
    @IBAction func onBook(_ sender: Any) {
        
        
        selectedRestaurant = self.restaurant
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookingVC" ) as! BookingVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func showMenu(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "ShowMenuVC" ) as! ShowMenuVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
}
