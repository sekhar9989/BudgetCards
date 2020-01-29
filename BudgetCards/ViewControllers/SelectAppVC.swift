
import UIKit
import NVActivityIndicatorView

class SelectAppVC: UIViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
//        startAnimating(message : "Loading...",type: NVActivityIndicatorType.ballRotateChase)
    }
    
    @IBAction func actionBudget(_ sender: Any) {
        pushTo(VC: "ListVC")
    }
    
    @IBAction func actionCards(_ sender: Any) {
        pushTo(VC: "HomeVC")
    }
    
    @IBAction func actionSetting(_ sender: Any) {
        pushTo(VC: "SettingsVC")
    }
    
}
