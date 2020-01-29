

import UIKit

class LaunchVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var constraintYofRoundSuper: NSLayoutConstraint!
    @IBOutlet weak var btnSignIn: MyButton!
    @IBOutlet weak var btnSignUp: MyButton!
    @IBOutlet weak var vwRound: RoundedView!
    @IBOutlet weak var lbl: GradientLabel!
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignIn.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnSignUp.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        vwRound.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vwRound.addGradiantColor()
        lbl.gradientColors = [UIColor.red.cgColor,UIColor.green.cgColor,UIColor.blue.cgColor]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        constraintYofRoundSuper.constant = (self.view.frame.height / 2) + 35
        if UserDefaults.standard.value(forKey: "userID") != nil {
            if UserDefaults.standard.value(forKey: "AppLock") != nil {
                pushTo(VC: "SecurityVC")
            } else {
                pushTo(VC: "SelectAppVC")
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionSignIn(_ sender: Any) {
        pushTo(VC: "SignInVC")
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        pushTo(VC: "SignUpVC")
    }
}

