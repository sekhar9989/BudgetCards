

import UIKit
import LocalAuthentication

class SecurityVC: UIViewController {
    
    @IBOutlet weak var txtFldPIN: UITextField!
    @IBOutlet weak var constraintYofRoundSuper: NSLayoutConstraint!
    @IBOutlet weak var btnGo: MyButton!
    @IBOutlet weak var vwRound: RoundedView!
    @IBOutlet weak var btnForgotPIN: UIButton!
    
    var context = LAContext()
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintYofRoundSuper.constant = (self.view.frame.height / 2) + 35
        authenticateUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vwRound.addGradiantColor()
    }
    
    func authenticateUser() {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "App Lock" ) { success, error in
            
            if success {
                //Move to the main thread because a state update triggers UI changes.
                DispatchQueue.main.async { [unowned self] in
                    toastMessage("Success")
                    self.pushTo(VC: "SelectAppVC")
                }
            } else {
                toastMessage(error?.localizedDescription ?? "Failed to authenticate")
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionForgotPIN(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure", message: "Your AppLock will be removed and you can create new PIN after SignIn again", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let proceed = UIAlertAction(title: "Proceed", style: .default) { (Action) in
            UserDefaults.standard.removeObject(forKey: "userID")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "AppLock")
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(proceed)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionGo(_ sender: Any) {
        self.view.endEditing(true)
        if txtFldPIN.text!.isEmpty {
            toastMessage("Please enter your secret PIN")
        } else if txtFldPIN.text!.count != 4 {
            toastMessage("Please enter your 4 digit PIN")
        } else if txtFldPIN.text != UserDefaults.standard.value(forKey: "AppLock") as? String {
            toastMessage("Invalid PIN")
        } else {
            pushTo(VC: "SelectAppVC")
        }
    }
}

extension SecurityVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            if textField.text?.count == 4 {
                toastMessage("maximum 4 digits only")
                return false
            } else if textField.text?.count == 3 && (txtFldPIN.text! + string) == UserDefaults.standard.value(forKey: "AppLock") as? String {
                pushTo(VC: "SelectAppVC")
            }
        }
        return true
    }
}
