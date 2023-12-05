import UIKit
import Lottie


extension String {
    
    
    func emailIsCorrect() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d{10}$"#
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}



func showAlerOnTop(message:String){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
      // completion?(true)
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
}

func showOkAlertAnyWhereWithCallBack(message:String,completion:@escaping () -> Void){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
       completion()
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
  
}

func showConfirmationAlert(message: String, yesHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        UIApplication.topViewController()!.present(alertController, animated: true, completion: nil)
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.connectedScenes
                                        .compactMap { $0 as? UIWindowScene }
                                        .flatMap { $0.windows }
                                        .first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}



extension DateFormatter {
   static func POSIX() -> DateFormatter {
       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       return dateFormatter
   }
}

extension UIView {
    
    func dropShadow(scale: Bool = true , height:Int = 3 , shadowRadius:CGFloat = 3,radius:CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: height)
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        layer.cornerRadius = radius
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
}





extension UITableView {
    
    func registerCells(_ cells : [UITableViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: cell))
        }
    }
}

 
extension UICollectionView {
    
    func registerCells(_ cells : [UICollectionViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: cell))
        }
    }
}

 

 
extension UIColor {
   static var appColor: UIColor {
       return UIColor(hex: 0x3C8089)
   }
   
   convenience init(hex: Int, alpha: CGFloat = 1.0) {
       let red = CGFloat((hex >> 16) & 0xFF) / 255.0
       let green = CGFloat((hex >> 8) & 0xFF) / 255.0
       let blue = CGFloat(hex & 0xFF) / 255.0
       
       self.init(red: red, green: green, blue: blue, alpha: alpha)
   }
}


extension String {
    func encodedURL() -> String {
        
        return self.replacingOccurrences(of: " ", with: "%20")
        //return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

var defaultURlImage = "https://feelgoodfoodie.net/wp-content/uploads/2021/05/Chickpea-Burger-08.jpg"

struct LottieAnimations {
   static let anim1 = "anim1"
   static let anim2 = "anim2"
}


extension UIViewController {
    
    func setLottie(animationView: inout LottieAnimationView,animationName:String,mode:LottieLoopMode) {
        animationView.animation = LottieAnimation.named(animationName)
        animationView.loopMode = mode
        animationView.contentMode = .scaleAspectFit
        animationView.play()
    }
}
