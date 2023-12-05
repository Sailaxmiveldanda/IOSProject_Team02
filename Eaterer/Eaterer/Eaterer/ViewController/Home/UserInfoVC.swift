

import UIKit

class UserInfoVC: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.username.text = UserDefaultsManager.shared.getUserName()
        self.name.text = UserDefaultsManager.shared.getName()
        self.email.text = UserDefaultsManager.shared.getEmail()
        self.phone.text = UserDefaultsManager.shared.getPhone()
    }
    

    @IBAction func onSignOut(_ sender: Any) {
        UserDefaultsManager.shared.clearUserDefaults()
        SceneDelegate.shared!.loginCheckOrRestart()
    }

    @IBAction func onDelete(_ sender: Any) {
        
        
        showConfirmationAlert(message: "Are you sure want to delete your account?") { _ in
            
            FireStoreManager.shared.deleteAccount(email: UserDefaultsManager.shared.getEmail().lowercased()) { error in
                if let error = error {
                    // Handle the error
                    print("Error deleting account: \(error.localizedDescription)")
                } else {
                    // Account deleted successfully
                    print("Account deleted successfully")
                    
                    
                   UserDefaultsManager.shared.clearUserDefaults()
                    
                    showOkAlertAnyWhereWithCallBack(message: "Account deleted successfully" ) {
                     
                        SceneDelegate.shared!.loginCheckOrRestart()
                      
                    }
                }
            }
            
        }
       
        
        
    }
    
    @IBAction func onUpdateProfile(_ sender: Any) {
        if validate(){
            self.updateProfile()
        }
    }
    
    func updateProfile(){
        let userdata = ["username": UserDefaultsManager.shared.getUserName(), "email": self.email.text ?? "", "name": self.name.text ?? "", "phone": self.phone.text ?? "", "password": UserDefaultsManager.shared.getPassword()]
        
        FireStoreManager.shared.updateProfile(documentid: UserDefaultsManager.shared.getDocumentId(), userData: userdata) { success in
            if success {
                UserDefaultsManager.shared.saveData(name: self.name.text ?? "", username: UserDefaultsManager.shared.getUserName(), phone: self.phone.text ?? "", email: self.email.text ?? "", password: UserDefaultsManager.shared.getPassword())

                showAlerOnTop(message: "Profile Updated Successfully")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
  
    func validate() ->Bool {
    
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
        
        
        return true
    }
}

extension UserInfoVC {
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}

