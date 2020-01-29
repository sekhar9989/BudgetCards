
import UIKit

class FullDetailsVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAppointment: UILabel!
    @IBOutlet weak var lblReminder: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lblSource: UILabel!
    
    //MARK:- Variables
    var dict = Dictionary<String, Any>()
    let arrType = ["Income","Expenditure"]

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        switch dict["type"] as! String {
        case arrType[0] :
            lblSource.text = "Source"
        case arrType[1] :
            lblSource.text = "Spent Area"
        default:
            break
        }
        lblTitle.text = dict["amount"] as? String
        lblHeader.text = dict["type"] as? String
        lblDescription.text = dict["note"] as? String
        lblAppointment.text = dict["date"] as? String
        lblReminder.text = dict["source"] as? String
        if (dict["img"] as! String).count < 3 {
            imgVw.image = ConvertBase64StringToImage(imageBase64String: dict["img"] as! String)
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateBudgetVC") as! CreateBudgetVC
        nextVC.dict = dict
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func actionFullImg() {
        if (dict["img"] as! String).count < 3 {
            return
        }
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Image!VC") as! ImageVC
        nextVC.img = imgVw.image!
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
