

import UIKit
import Firebase
import NVActivityIndicatorView

class SignInVC: UIViewController, NVActivityIndicatorViewable {
    
    //MARK:- Outlets
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var constraintYofRoundSuper: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignIn: ShadowButton!
    @IBOutlet weak var vwRound: RoundedView!
    @IBOutlet weak var btnForgotPswrd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwRound.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnSignIn.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnBack.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        vwRound.addGradiantColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        constraintYofRoundSuper.constant = (self.view.frame.height / 2) + 35
    }
    
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        self.view.endEditing(true)
        if txtFldEmail.text!.isEmpty {
            toastMessage("Please enter email")
            return
        }
        if !isValidEmail(emailStr: txtFldEmail.text!) {
            toastMessage("Please enter valid email")
            return
        }
        if txtFldPassword.text!.isEmpty {
            toastMessage("Please enter password")
            return
        }
        startAnimating()
        Auth.auth().signIn(withEmail: txtFldEmail.text!, password: txtFldPassword.text!) { [weak self] user, error in
            guard let strongSelf = self else { return }
            // ...
            if error != nil {
                toastMessage(error?.localizedDescription ?? "Something went wrong")
            } else {
                UserDefaults.standard.set(user!.user.uid, forKey: "userID")
                UserDefaults.standard.set(user!.user.email, forKey: "email")
                strongSelf.pushTo(VC: "SelectAppVC")
                toastMessage("SignIn success")
            }
            self?.stopAnimating()
        }
    }
    
    @IBAction func actionForgotPassw(_ sender: Any) {
        pushTo(VC: "ForgotpasswordVC")
    }
}
