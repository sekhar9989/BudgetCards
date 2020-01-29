
import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var switchAppLock: UISwitch!
    @IBOutlet weak var txtFldEnterPIN: UITextField!
    @IBOutlet weak var txtFldConfirmPIN: UITextField!
    @IBOutlet weak var btnSave: MyButton!
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        switchAppLock.isOn = UserDefaults.standard.value(forKey: "AppLock") != nil
        txtFldConfirmPIN.text = UserDefaults.standard.value(forKey: "AppLock") as? String
        txtFldEnterPIN.text = UserDefaults.standard.value(forKey: "AppLock") as? String
        hideFields()
    }
    
    func hideFields() {
        txtFldEnterPIN.isHidden = !switchAppLock.isOn
        txtFldConfirmPIN.isHidden = !switchAppLock.isOn
        btnSave.isHidden = !switchAppLock.isOn
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "AppLock")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        self.view.endEditing(true)
        if UserDefaults.standard.value(forKey: "AppLock") != nil {
            let alertController = UIAlertController(title: "Are you sure", message: "Your AppLock will be removed and you can create new PIN after SignIn again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let proceed = UIAlertAction(title: "LogOut", style: .default) { (Action) in
                self.logout()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(proceed)
            self.present(alertController, animated: true, completion: nil)
        } else {
            logout()
        }
    }
    
    @IBAction func actionSwitch(_ sender: UISwitch) {
        self.view.endEditing(true)
        hideFields()
        if !sender.isOn {
            if UserDefaults.standard.value(forKey: "AppLock") != nil {
                UserDefaults.standard.removeObject(forKey: "AppLock")
                toastMessage("Successfully remove AppLock")
            }
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.view.endEditing(true)
        if txtFldEnterPIN.text!.isEmpty {
            toastMessage("Please enter PIN")
        } else if txtFldEnterPIN.text!.count != 4 {
            toastMessage("Please enter 4 digit PIN")
        } else if txtFldConfirmPIN.text!.isEmpty {
            toastMessage("Please enter confirm PIN")
        } else if txtFldEnterPIN.text != txtFldEnterPIN.text {
            toastMessage("PINs doen't matched")
        } else {
            UserDefaults.standard.set(txtFldEnterPIN.text, forKey: "AppLock")
            toastMessage("AppLock turned on successfully")
            popToBack()
        }
    }
}

extension SettingsVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            if textField.text?.count == 4 {
                toastMessage("maximum 4 digits only")
                return false
            }
        }
        return true
    }
}
