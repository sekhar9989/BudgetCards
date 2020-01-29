
import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var imgVw: UIImageView!
    
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgVw.image = img
    }
    
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    
}
