 
import UIKit
import SDWebImage

struct BookingData{
    var restaurant: String?
    var dateTime: String?
    var amount: String?
    var member: String?
    var location: String?
}

var selectedRestaurant : RestaurantsModel!

var folded = false


class BookingTableView: UITableViewController, BookingDelegate {
    func didTapRequestButton(in cell: BookingCell, model: BookingData) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "PaymentVC" ) as! PaymentVC
        
        vc.receivedBooking = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        folded = false
        setup()
    }

    // MARK: Helpers
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}

// MARK: - TableView

extension BookingTableView {

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as BookingCell = cell else {
            return
        }

        cell.backgroundColor = .clear

        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath) as! BookingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.delegate = self
        return cell
    }

    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell

        if cell.isAnimating() {
            return
        }

        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
            folded = true
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
            folded = false
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // fix https://github.com/Ramotion/folding-cell/issues/169
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
}

protocol BookingDelegate: AnyObject {
    func didTapRequestButton(in cell: BookingCell, model : BookingData)
}
 
class BookingCell: FoldingCell {
 
    let dateTimePicker = GlobalDateTimePicker()
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var time2: UILabel!
   
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var persons: UILabel!
    @IBOutlet weak var amount2: UILabel!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var resImage2: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var countryAndPin: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var floatingRatingView: FloatRatingView!
    
    var numberOfPersons = 2 // Initial value
   
    var selectedDate = "Today"
    var selectedTime = "6.30 PM"
    weak var delegate: BookingDelegate?

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        setData()
    }
   
    func setData() {
        self.amount2.text = "$\(selectedRestaurant.bookingAmount)"
        self.resName.text =  selectedRestaurant.name
        self.location.text = selectedRestaurant.location
        self.countryAndPin.text = selectedRestaurant.countryAndPin
        self.floatingRatingView.rating = selectedRestaurant.rating.toDouble() ?? 1.0
        self.time.text = selectedTime
        self.date.text = selectedDate
        self.updatePersonsLabel()
        
        
        dateFormatter = DateFormatter.POSIX()
        dateFormatter.dateFormat = "dd-MMMM-yyyy h:mm a"
        dateTimePicker.uIDatePickerMode = .dateAndTime
    
        
        resImage.sd_setImage(with: selectedRestaurant.image.encodedURL().toURL() ?? defaultURlImage.encodedURL().toURL()!, placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { image, error, cacheType, imageURL in
            self.resImage2.image =  image
        })
        
    }
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    @IBAction func onDateTime(_ sender: Any) {
        
        if(folded) {
            return
        }
        self.dateTimePicker.onDone = { date in
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "dd MMM"
               self.selectedDate = dateFormatter.string(from: date)
               
               dateFormatter.dateFormat = "h:mm a"
               self.selectedTime = dateFormatter.string(from: date)
               
                self.time.text = self.selectedTime
                self.date.text = self.selectedDate
                self.time2.text = self.selectedTime
                self.date2.text = self.selectedDate

           }
        self.dateTimePicker.modalPresentationStyle = .overCurrentContext
        bookingVC.present(self.dateTimePicker, animated: true, completion: nil)
        
    }
    
}

// MARK: - Actions ⚡️

extension BookingCell {

    
      
       @IBAction func onMinus(_ sender: Any) {
           if numberOfPersons > 1 {
               numberOfPersons -= 1
               updatePersonsLabel()
           }
       }

       @IBAction func onPlus(_ sender: Any) {
           if numberOfPersons < 15 {
               numberOfPersons += 1
               updatePersonsLabel()
           }
       }
       
       func updatePersonsLabel() {
           self.persons.text = "\(numberOfPersons)"
       }
    
    @IBAction func requestTap(_ sender: UIButton) {
        let bookingData = BookingData(restaurant: self.resName.text ?? "",dateTime: "\(date2.text ?? "") \(time2.text ?? "")", amount: self.amount2.text ?? "", member: self.persons.text ?? "", location: self.location.text ?? "")
        delegate?.didTapRequestButton(in: self, model: bookingData)
        }
    
}

