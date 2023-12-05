
import UIKit
import AnimatedGradientView

class PaymentVC: UIViewController,UITextFieldDelegate {

   @IBOutlet weak var name: UITextField!
   @IBOutlet weak var number: UITextField!
   @IBOutlet weak var cvv: UITextField!
   @IBOutlet weak var billingAddress: UITextField!
  
    @IBOutlet weak var gradiantView: UIView!
    @IBOutlet weak var amount: UILabel!
   var selectedCardText = ""
    var receivedBooking: BookingData?

   override func viewDidLoad() {
       super.viewDidLoad()
       self.setAnimatedView()
     
       amount.text = "$\(selectedRestaurant.bookingAmount)"
       
       self.number.delegate = self
       self.cvv.delegate = self
       self.name.delegate = self
       self.cvv.delegate = self
       self.cvv.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

       self.number.delegate = self
       self.number.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
   }
   @IBAction func onPay(_ sender: Any) {
       let name = self.name.text!
       let number = self.number.text!
       let cvv = self.cvv.text!

       if name.isEmpty || number.isEmpty || cvv.isEmpty {
           showAlert(message: "Please enter all the details")
       } else if self.billingAddress.text!.isEmpty {
           showAlert(message: "Please enter billing address")
       } else if number.count != 16 { // Check if the account number is not exactly 16 digits
           showAlert(message: "Card number must be 16 digits")
       } else if cvv.count != 4 { // Check if the CVV is not exactly 4 digits
           showAlert(message: "CVV must be 4 digits")
       } else {
           
           showOkAlertAnyWhereWithCallBack(message: "Booking Completed ✅ ") {
               let vc = self.storyboard?.instantiateViewController(withIdentifier:  "BookingDetailVC" ) as! BookingDetailVC
                       
               vc.receivedBooking = self.receivedBooking
               self.navigationController?.pushViewController(vc, animated: true)

           }
       }
   }


   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if textField == self.name {
           let allowedCharacterSet = CharacterSet.letters
           let characterSet = CharacterSet(charactersIn: string)
           return allowedCharacterSet.isSuperset(of: characterSet)
       } else if textField == self.number || textField == self.cvv {
           let allowedCharacterSet = CharacterSet.decimalDigits
           let characterSet = CharacterSet(charactersIn: string)
           return allowedCharacterSet.isSuperset(of: characterSet)
       }
       return true
   }
    
 
   
   func showAlert(message:String) {
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
       self.present(alert, animated: true, completion: nil)
   }
   
   
}
 

extension PaymentVC {
   
   // Add a common method to limit text field length
      @objc func textFieldDidChange(_ textField: UITextField) {
          if textField == self.cvv {
              if let text = textField.text, text.count > 4 {
                  textField.text = String(text.prefix(4))
              }
          } else if textField == self.number {
              if let text = textField.text, text.count > 16 {
                  textField.text = String(text.prefix(16))
              }
          }
      }
   
   
}
 



extension PaymentVC {

    func setAnimatedView() {

        let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.direction = .up
        let mainColor = "#3C8089"
        animatedGradient.animationValues = [
            (colors: [mainColor, "#7ED5E8"], .up, .axial),
            (colors: [mainColor, "#7ED5E8", "#fcb045"], .right, .axial),
    
        ]
        gradiantView.addSubview(animatedGradient)

        // Start the animation
        animatedGradient.startAnimating()
    }
}
