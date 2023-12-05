

import UIKit
import SDWebImage
import AnimatedGradientView

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var animatedGradient: AnimatedGradientView!
    @IBOutlet weak var collectionView1: UICollectionView?
    @IBOutlet weak var collectionView2: UICollectionView?
    var categories:[CategoryModel] = []
    var allOffers:[OffersModel] = []
    var allRestaurants:[RestaurantsModel] = []
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    let layout1: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    let layout2: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView1?.backgroundColor = .clear
        self.collectionView2?.backgroundColor = .clear
       
        self.setCollectionLayout()
        
        self.handleCollectionViewHeight()

        ViewModel.shared.getCategories { list in
            self.categories = list
            self.collectionView1?.reloadData()
        }
        
        ViewModel.shared.getAllRestaurants { list in
            self.allRestaurants = list
            self.handleCollectionViewHeight()
            self.collectionView2?.reloadData()
        }
        
        ViewModel.shared.getAllOffers { list in
            self.allOffers = list
            self.setupImageSlideShow()
        }
        
       
       // self.imageSlideShow.dropShadow(radius:10)
        self.imageSlideShow.clipsToBounds = true
        
       // self.setAnimatedView()
         animatedGradient = AnimatedGradientView(frame: view.bounds)
           animatedGradient.direction = .up
           animatedGradient.animationValues = [
               (colors: ["#2BC0E4", "#EAECC6"], direction: .up, type: .axial),
               (colors: ["#833ab4", "#fd1d1d", "#fcb045"], direction: .right, type: .axial),
               (colors: ["#003973", "#E5E5BE"], direction: .down, type: .axial),
               (colors: ["#1E9600", "#FFF200", "#FF0000"], direction: .left, type: .axial)
           ]
           view.insertSubview(animatedGradient, at: 0)

    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)

           // Update the frame of the AnimatedGradientView
           animatedGradient.frame = CGRect(origin: .zero, size: size)
               }
    
    func setCollectionLayout(){
        
        self.collectionView1?.delegate = self
        self.collectionView1?.dataSource = self
        self.collectionView1?.collectionViewLayout = layout1
        
        self.collectionView2?.delegate = self
        self.collectionView2?.dataSource = self
        self.collectionView2?.collectionViewLayout = layout2
    }
    
    
    func handleCollectionViewHeight(){
        let itemsPerRow = 2
        
        let totalItems = allRestaurants.count
        
            let spacing: CGFloat = 10
        
        
        let numRows = Int(ceil(Double(totalItems) / Double(itemsPerRow)))

        let rowHeight: CGFloat = 150

        let totalHeight = CGFloat(numRows) * rowHeight + CGFloat(numRows - 1) * spacing

        collectionHeight.constant = totalHeight

    }

    @IBAction func onUserInfo(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "UserInfoVC" ) as! UserInfoVC
                
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onSearch(_ sender: Any) {
        
        let searchText = self.searchTF.text!

        if(searchText.isEmpty) {
            showAlerOnTop(message: "Nothing Found")
            return
        }
        
        if self.allRestaurants.isEmpty {
            ViewModel.shared.getAllRestaurants { list in
                let filteredRestaurants = list.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                self.navigateToSearchVC(with: filteredRestaurants)
            }
        } else {
            let filteredRestaurants = self.allRestaurants.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            self.navigateToSearchVC(with: filteredRestaurants)
        }
    }
    
    func navigateToSearchVC(with restaurants: [RestaurantsModel]) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.allRestaurants = restaurants
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func onOffer(_ sender: Any) {
       
        self.getOffersData()
    }

   func getOffersData() {
        if self.allRestaurants.isEmpty {
            ViewModel.shared.getAllRestaurants { list in
                let filteredRestaurants = list.filter { $0.haveOffer == true  }
                self.navigateToOfferVC(with: filteredRestaurants)
            }
        } else {
            let filteredRestaurants = allRestaurants.filter { $0.haveOffer == true  }
            self.navigateToOfferVC(with: filteredRestaurants)
        }
    }
    
    
    func navigateToOfferVC(with restaurants: [RestaurantsModel]) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "OffersVC" ) as! OffersVC
        vc.allRestaurants = restaurants
        vc.imageUrl = self.allOffers[self.imageSlideShow.currentPage].image ?? defaultURlImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1{
            return categories.count
        } else if collectionView == collectionView2 {
            return allRestaurants.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        if collectionView == collectionView1{
            
            let category = categories[indexPath.row]
        
            cell.image.sd_setImage(with: category.foodImage.encodedURL().toURL() ?? defaultURlImage.encodedURL().toURL()!, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                cell.image.image =  image
            })
            
            cell.titleLabel.text = category.title
            
        } else if collectionView == collectionView2 {
            let restaurant = allRestaurants[indexPath.row]
            cell.image.sd_setImage(with: restaurant.image.encodedURL().toURL() ?? defaultURlImage.encodedURL().toURL()!, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
                cell.image.image =  image
            })
            cell.restaurentName?.text = restaurant.name
           
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1{
            let collectionViewWidth = collectionView.frame.width
            let cellWidth = (collectionViewWidth - 40) / 3
            let cellHeight: CGFloat = 130
            return CGSize(width: cellWidth, height: cellHeight)
        } else if collectionView == collectionView2 {
            let collectionViewWidth = collectionView.frame.width
                    let cellWidth = (collectionViewWidth - 10) / 2
                    let cellHeight: CGFloat = 150
                    return CGSize(width: cellWidth, height: cellHeight)
        }
        return CGSize(width: 130, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "CategoryVC" ) as! CategoryVC
                    
            vc.category = self.categories[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == collectionView2{
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "RestaurantDetailVC" ) as! RestaurantDetailVC
            vc.restaurant = self.allRestaurants[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}



 
extension HomeVC {
    
    
    func setupImageSlideShow() {
        
        let sdWebImageSource = self.allOffers.compactMap { billboard -> SDWebImageSource? in
            if let imageUrlString = billboard.image?.encodedURL(), let url = URL(string: imageUrlString) {
                return SDWebImageSource(url: url)
            }
            return nil
        }
        
        imageSlideShow.slideshowInterval = 3.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        // Adjust the indicator size
        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
        imageSlideShow.pageIndicator = pageControl
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.delegate = self
        imageSlideShow.setImageInputs(sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlideShow.addGestureRecognizer(recognizer)
        
        
    }
    
    @objc func didTap() {
        self.getOffersData()
     }
  
}


extension HomeVC: ImageSlideshowDelegate {
        
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
    }
 }
/*
extension HomeVC {

    func setAnimatedView() {

   //     let animatedGradient = AnimatedGradientView(frame: view.bounds)
    //    animatedGradient.direction = .up
    //    let mainColor = "#3C8089"
    //    animatedGradient.animationValues = [
      //      (colors: [mainColor, "#7ED5E8"], .up, .axial),
     //       (colors: [mainColor, "#fd1d1d", "#fcb045"], .right, .axial),
     //       (colors: [mainColor, "#E5E5BE"], .down, .axial),
       //     (colors: [mainColor, "#FFF200", "#FF0000"], .left, .axial)
    //    ]
      //  gradiantViewContainer.addSubview(animatedGradient)

        // Start the animation
      //  animatedGradient.startAnimating()
        let animatedGradient = AnimatedGradientView(frame: view.bounds)
           animatedGradient.direction = .up
           animatedGradient.animationValues = [
               (colors: ["#2BC0E4", "#EAECC6"], direction: .up, type: .axial),
               (colors: ["#833ab4", "#fd1d1d", "#fcb045"], direction: .right, type: .axial),
               (colors: ["#003973", "#E5E5BE"], direction: .down, type: .axial),
               (colors: ["#1E9600", "#FFF200", "#FF0000"], direction: .left, type: .axial)
           ]
           view.insertSubview(animatedGradient, at: 0)
    }
}
*/
