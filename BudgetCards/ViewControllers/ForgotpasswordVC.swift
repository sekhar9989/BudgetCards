

import UIKit
import Firebase
import NVActivityIndicatorView

class ForgotpasswordVC: UIViewController, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var txtFldemail: UITextField!
    @IBOutlet weak var constraintYofRoundSuper: NSLayoutConstraint!
    @IBOutlet weak var btnReset: MyButton!
    @IBOutlet weak var vwRound: RoundedView!
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        vwRound.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnReset.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vwRound.addGradiantColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        constraintYofRoundSuper.constant = (self.view.frame.height / 2) + 35
    }
    
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func actionReset(_ sender: Any) {
        self.view.endEditing(true)
        if txtFldemail.text!.isEmpty {
            toastMessage("Please enter registered email")
            return
        }
        if !isValidEmail(emailStr: txtFldemail.text!) {
            toastMessage("Enter valid email")
            return
        }
        self.startAnimating()
        Auth.auth().sendPasswordReset(withEmail: txtFldemail.text!) { error in
            if error != nil {
                toastMessage(error?.localizedDescription ?? "Something went wrong, please try again later")
            } else {
                toastMessage("Password reset mail sent to your email")
                self.popToBack()
            }
            self.stopAnimating()
        }
    }
}
