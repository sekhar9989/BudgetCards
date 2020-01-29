

import UIKit
import Firebase
import NVActivityIndicatorView

class CreateBudgetVC: UIViewController, NVActivityIndicatorViewable {
    
    //MARK:- Outles
    @IBOutlet weak var txtFldType: UITextField!
    @IBOutlet weak var txtFldAmount: UITextField!
    @IBOutlet weak var txtFldSource: UITextField!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var txtVwNotes: UITextView!
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK:- Constants and Varibales
    let objGalleryCamera = GalleryCamera()
    var selectedImage = "s"
    let picker = UIDatePicker()
    let dateformatter = DateFormatter()
    let toolBar = UIToolbar()
    var dict : Dictionary<String, Any>!
    var typePicker = UIPickerView()
    let arrType = ["Income","Expenditure"]
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.delegate = self
        txtFldType.inputView = typePicker
        objGalleryCamera.delegate = self
        
        picker.timeZone = NSTimeZone.local
        picker.datePickerMode = UIDatePicker.Mode.dateAndTime
        picker.maximumDate = Date()
        // ToolBar
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = #colorLiteral(red: 0.5882352941, green: 0.137254902, blue: 0.5882352941, alpha: 0.35)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        txtFldDate.inputAccessoryView = toolBar
        txtFldDate.inputView = picker
        loadData()
    }
    
    //MARK:- Custom Functions
    func loadData() {
        if dict != nil {
            txtFldType.text = dict["type"] as? String
            txtFldSource.text = dict["source"] as? String
            txtFldDate.text = dict["date"] as? String
            txtVwNotes.text = dict["note"] as? String
            txtFldAmount.text = dict["amount"] as? String
            switch dict["type"] as! String {
            case arrType[0] :
                lblSource.text = "Source of Income"
                txtFldSource.placeholder = "Enter source of income"
            case arrType[1] :
                lblSource.text = "Area of spent"
                txtFldSource.placeholder = "Enter spent area"
            default:
                break
            }
            if (dict["note"] as? String)!.count > 1 {
                txtVwNotes.textColor = .black
            }
            if (dict["img"] as? String)?.count ?? 0 > 3 {
                selectedImage = dict["img"] as! String
                btnAddImage.setImage(ConvertBase64StringToImage(imageBase64String: selectedImage), for: .normal)
            }
            btnSave.setTitle("Update", for: .normal)
        }
    }
    
    //MARK:- IBActions
    @objc func done() {
        dateformatter.dateFormat = "dd-MM-yyyy  hh:mm a"
        txtFldDate.text = dateformatter.string(from: picker.date)
        txtFldDate.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        txtFldDate.resignFirstResponder()
    }
    
    @IBAction func actionback(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func actionAddImage(_ sender: Any) {
        objGalleryCamera.showAlertChooseImage(self)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if txtFldType.text!.isEmpty {
            toastMessage("Please select type")
        } else if txtFldAmount.text!.isEmpty {
            toastMessage("Please enter amount")
        } else if txtFldSource.text!.isEmpty {
            toastMessage("Please enter source")
        } else if txtFldDate.text!.isEmpty {
            toastMessage("Please select date")
        } else {
            if dict == nil {
                if UserDefaults.standard.value(forKey: "TransactionId") == nil {
                    UserDefaults.standard.set(1, forKey: "TransactionId")
                } else if UserDefaults.standard.value(forKey: "TransactionId") != nil {
                    UserDefaults.standard.set(UserDefaults.standard.value(forKey: "TransactionId") as! Int + 1, forKey: "TransactionId")
                }
            }
            let param = [
                "type" : txtFldType.text!,
                "amount" : txtFldAmount.text!,
                "note" : txtVwNotes.text!,
                "date" : txtFldDate.text!,
                "img" : selectedImage,
                "source" : txtFldSource.text!,
                "id" : dict == nil ? UserDefaults.standard.value(forKey: "TransactionId")!:dict["id"]!
                ] as [String : Any]
            
            startAnimating()
            Firebase.userRef.document(UserDefaults.standard.value(forKey: "userID") as! String).collection("Transactions").document(dict == nil ? "\(UserDefaults.standard.value(forKey: "TransactionId")!)" :"\(dict["id"]!)" ).setData(param as [String : Any], completion: { (error) in
                if error != nil {
                    toastMessage( error?.localizedDescription ?? "Something went wrong, please try again later")
                    return
                } else {
                    toastMessage("Document saved successfully")
                    if self.dict == nil {
                        self.popToBack()
                    } else {
                        self.navigationController?.backToViewController( ofClass: ListVC.self)
                    }
                }
                self.stopAnimating()
            })
        }
    }
}

extension CreateBudgetVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtVwNotes.textColor == UIColor.lightGray {
            txtVwNotes.text = nil
            txtVwNotes.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtVwNotes.text.isEmpty {
            txtVwNotes.text = "Write a note"
            txtVwNotes.textColor = UIColor.lightGray
        }
    }
}

extension CreateBudgetVC: ImageSelected {
    func finishPassing(selectedImg: UIImage) {
        selectedImage = ConvertImageToBase64String(img: selectedImg)
        btnAddImage.setImage(selectedImg, for: .normal)
    }
}

extension CreateBudgetVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            txtFldType.text = arrType[row]
        }
        return arrType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePicker {
            txtFldType.text = arrType[row]
            self.view.endEditing(true)
            if row == 1 {
                lblSource.text = "Area of spent"
                txtFldSource.placeholder = "Enter spent area"
            } else {
                lblSource.text = "Source of Income"
                txtFldSource.placeholder = "Enter source of income"
            }
        }
    }
}
