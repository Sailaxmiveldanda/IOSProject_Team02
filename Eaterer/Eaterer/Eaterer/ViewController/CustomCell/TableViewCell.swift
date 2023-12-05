
import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var restoImage: UIImageView!
    @IBOutlet weak var restoName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
