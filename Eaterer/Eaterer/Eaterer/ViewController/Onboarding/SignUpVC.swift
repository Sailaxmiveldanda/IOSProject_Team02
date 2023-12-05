

import UIKit
import Lottie

class SignUpVC: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    let datePicker = UIDatePicker()

    @IBOutlet weak var animationView: LottieAnimationView!
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phone.keyboardType = .phonePad
        self.setLottie(animationView: &animationView, animationName: LottieAnimations.anim1, mode: .loop)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        if validate(){
            FireStoreManager.shared.signUp(username: self.username.text ?? "", name: self.name.text ?? "", email: self.email.text ?? "", phone: self.phone.text ?? "", password: self.password.text ?? "")
        }
        
    }

    @IBAction func onLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validate() ->Bool {
        
        if(self.username.text!.isEmpty) {
            showAlerOnTop(message: "Please enter user name.")
            return false
        }
        
        if(self.name.text!.isEmpty) {
            showAlerOnTop(message: "Please enter name.")
            return false
        }
        
        if(self.email.text!.isEmpty) {
            showAlerOnTop(message: "Please enter email.")
            return false
        }
        
        if !email.text!.emailIsCorrect() {
            showAlerOnTop(message: "Please enter valid email id")
            return false
        }
        
        if(self.phone.text!.isEmpty) {
            showAlerOnTop(message: "Please enter phone.")
            return false
        }
        
        if !isValidPhoneNumber(self.phone.text ?? "") {
            showAlerOnTop(message: "Please enter valid phone.")
            return false
        }
        
        if(self.password.text!.isEmpty) {
            showAlerOnTop(message: "Please enter password.")
            return false
        }
        
        if(self.confirmPassword.text!.isEmpty) {
            showAlerOnTop(message: "Please enter confirm password.")
            return false
        }
        
        if(self.password.text! != self.confirmPassword.text!) {
            showAlerOnTop(message: "Password doesn't match")
            return false
        }
        
        if(self.password.text!.count < 5 || self.password.text!.count > 10 ) {
            
            showAlerOnTop(message: "Password  length shoud be 5 to 10")
            return false
        }
        
        
        return true
    }
}

extension SignUpVC{
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}


