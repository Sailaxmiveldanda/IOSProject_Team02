
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie

class LoginVC: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLottie(animationView: &animationView, animationName: LottieAnimations.anim1, mode: .loop)
    }
    
    @IBAction func onLogin(_ sender: Any) {
            if(username.text!.isEmpty) {
                showAlerOnTop(message: "Please enter your username.")
                return
            }

            if(self.password.text!.isEmpty) {
                showAlerOnTop(message: "Please enter your password.")
                return
            }
            else{
                FireStoreManager.shared.login(username: username.text?.lowercased() ?? "", password: password.text ?? "") { success in
                    if success{
                            SceneDelegate.shared?.loginCheckOrRestart()
                    }
                    
                }
            }
    }
    
    @IBAction func onReset(_ sender: Any) {
        self.username.text = ""
        self.password.text = ""
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "SignUpVC" ) as! SignUpVC
                
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onForgotPassword(_ sender: Any) {
       
    }

}
