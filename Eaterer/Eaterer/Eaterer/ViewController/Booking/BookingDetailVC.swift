
import UIKit

class BookingDetailVC: UIViewController {
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var member: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var amount: UILabel!

    var receivedBooking: BookingData?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.restaurant.text = receivedBooking?.restaurant
        self.dateTime.text = receivedBooking?.dateTime
        self.member.text = receivedBooking?.member
        self.location.text = receivedBooking?.location
        self.amount.text = receivedBooking?.amount
    }
    

    @IBAction func onDone(_ sender: Any) {
        SceneDelegate.shared?.loginCheckOrRestart()
    }

}
