import UIKit
import CoreMotion
 
class ShowMenuVC: UIViewController {

    @IBOutlet weak var imageMain: UIImageView!
    var startedLeftTilt = false
    var startedRightTilt = false
    var dateLastShake = NSDate(timeIntervalSinceNow: -2)
    var dateStartedTilt = NSDate(timeIntervalSinceNow: -2)
    var motionManager = CMMotionManager()
    let tresholdFirstMove = 3.0
    let tresholdBackMove = 0.5
    var imageArray : [UIImage] = []
    let menus = ["menu1", "menu2", "menu3", "menu4"]
    var shakeDirection: UIInterfaceOrientationMask = .all // Default to some sensible value

    var currentPageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        motionManager.gyroUpdateInterval = 0.01
    }
  
    

    override func viewDidAppear(_ animated: Bool) {
        
        // Pick a random menu from the array
        let selectedMenu = menus.randomElement()

        
        
        if let pdfURL = Bundle.main.url(forResource: selectedMenu, withExtension: "pdf") {
            let images = convertPDFToImages(pdfURL: pdfURL)
            
            // Process the array of images as desired
            if let images = images {
                
                self.imageArray = images
                
                self.imageMain.image = imageArray.first!
            }
        }
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (gyroData, error) in
            self.handleGyroData(rotation: gyroData?.rotationRate ?? CMRotationRate())
        }
    }

    // Stop motion updates when the view is no longer visible
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopGyroUpdates()
    }

    private func handleGyroData(rotation: CMRotationRate) {

        if fabs(rotation.z) > tresholdFirstMove && fabs(dateLastShake.timeIntervalSinceNow) > 0.3 {
            if !startedRightTilt && !startedLeftTilt {
                dateStartedTilt = NSDate()
                if rotation.z > 0 {
                    startedLeftTilt = true
                    startedRightTilt = false
                } else {
                    startedRightTilt = true
                    startedLeftTilt = false
                }
            }
        }

        if fabs(dateStartedTilt.timeIntervalSinceNow) >= 0.3 {
            startedRightTilt = false
            startedLeftTilt = false
        } else {
            if fabs(rotation.z) > tresholdBackMove {
                if startedLeftTilt && rotation.z < 0 {
                    dateLastShake = NSDate()
                    startedRightTilt = false
                    startedLeftTilt = false
                    self.shakeDirection = .landscapeRight
                    self.swipeLeft()
                    print("\\\n Shaked left\n/")
                } else if startedRightTilt && rotation.z > 0 {
                    dateLastShake = NSDate()
                    startedRightTilt = false
                    startedLeftTilt = false
                    self.shakeDirection = .landscapeLeft
                    self.swipeRight()
                    print("\\\n Shaked right\n/")
                }
            }
        }
    }

}

extension ShowMenuVC {

    func swipeLeft() {
        
        if(currentPageIndex < 0 ) {
            currentPageIndex = 0
        }else {
            currentPageIndex -= 1
        }
      
        updateImage()
    }

    func swipeRight() {
        if currentPageIndex < imageArray.count - 1 {
            currentPageIndex += 1
        }
        updateImage()
    }
    
    
    func updateImage() {
            guard currentPageIndex >= 0 && currentPageIndex < imageArray.count else {
                return
            }

            let newImage = imageArray[currentPageIndex]

            UIView.transition(with: imageMain, duration: 0.5, options: shakeDirection == .landscapeRight ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
                self.imageMain.image = newImage
            }, completion: nil)
        }


}



