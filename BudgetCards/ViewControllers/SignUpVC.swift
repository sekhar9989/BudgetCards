

import UIKit
import Firebase
import NVActivityIndicatorView

class SignUpVC: UIViewController, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var txtFldConfirmPassword: UITextField!
    @IBOutlet weak var constraintYofRoundSuper: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignUp: MyButton!
    @IBOutlet weak var vwRound: RoundedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwRound.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnBack.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnSignUp.addShadow(shadowColor: AppColors.purpleBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)

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
    
    @IBAction func actionSignUp(_ sender: Any) {
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
        if txtFldPassword.text!.count < 6 {
            toastMessage("Password required minimum 6 charecters")
            return
        }
        if txtFldConfirmPassword.text!.isEmpty {
            toastMessage("Please enter confirm password")
            return
        }
        if txtFldConfirmPassword.text!.count < 6 {
            toastMessage("Password required minimum 6 charecters")
            return
        }
        if txtFldPassword.text != txtFldConfirmPassword.text {
            toastMessage("Passwords doesn't match")
            return
        }
        startAnimating()
        Auth.auth().createUser(withEmail: txtFldEmail.text!, password: txtFldPassword.text!) { authResult, error in
            // ...
            if error != nil {
                toastMessage(error?.localizedDescription ?? "Something went wrong")
            } else {
                if let result = authResult {
                    let user = result.user
                    UserDefaults.standard.set(user.uid, forKey: "userID")
                    UserDefaults.standard.set(user.email, forKey: "email")
                    let userData = ["email": user.email,
                                    "uid": user.uid
                    ]
                    
                    Firebase.userRef.document(user.uid).setData(userData as [String : Any], completion: { (error) in
                        if error != nil {
                            toastMessage("Something went wrong, please try again later")
                            return
                        }
                        self.pushTo(VC: "SelectAppVC")
                    })
                }
            }
            self.stopAnimating()
        }
    }
}
