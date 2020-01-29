

import UIKit
import Firebase
import FirebaseFirestore


class CreateVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var colVwImages: UICollectionView!
    @IBOutlet weak var txtFldScreenName: UITextField!
    @IBOutlet weak var txtFldNameOnCard: UITextField!
    @IBOutlet weak var txtFldCardNo: UITextField!
    @IBOutlet weak var txtFldExpDate: UITextField!
    @IBOutlet weak var txtFldCVV: UITextField!
    @IBOutlet weak var txtFldPIN: UITextField!
    @IBOutlet weak var txtVwAdditional: UITextView!
    @IBOutlet weak var lblAddImages: UILabel!
    @IBOutlet weak var btnSave: MyButton!
    
    //MARK:- Variables
    let objGalleryCamera = GalleryCamera()
    var selectedImgs = [UIImage]()
    var selectedImages = [String]()

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        objGalleryCamera.delegate = self
    }

    //MARK:- IBActions
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.view.endEditing(true)
        if txtFldScreenName.text!.isEmpty {
            toastMessage("Please enter screening name")
            return
        }
        let param = [
            "type" : "card",
            "0" : txtFldScreenName.text!,
            "1" : txtFldNameOnCard.text!,
            "2" : txtFldCardNo.text!,
            "3" : txtFldExpDate.text!,
            "4" : txtFldCVV.text!,
            "5" : txtFldPIN.text!,
            "6" : txtVwAdditional.text!,
            "images" : selectedImages
            ] as [String : Any]
        Firebase.userRef.document(UserDefaults.standard.value(forKey: "userID") as! String).collection("documents").document(txtFldScreenName.text!).setData(param as [String : Any], completion: { (error) in
            if error != nil {
                toastMessage("Something went wrong, please try again later")
                return
            }
            toastMessage("Document saved successfully")
            self.popToBack()
        })
        
    }
    
    @IBAction func actionAddImage(_ sender: Any) {
        self.view.endEditing(true)
        if selectedImgs.count == 5 {
            toastMessage("maximum images selected")
            return
        }
        objGalleryCamera.showAlertChooseImage(self)
    }
    
    @IBAction func actionScan(_ sender: Any) {
//        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
//        cardIOVC?.modalPresentationStyle = .formSheet
//        present(cardIOVC!, animated: true, completion: nil)
//        self.present(self.storyboard?.instantiateViewController(withIdentifier: "CardScanner") as! CardScanner, animated: true, completion: nil)
    }
}

extension CreateVC: ImageSelected {
    func finishPassing(selectedImg: UIImage) {
        let uuid = UUID().uuidString
        // Create a reference to the file you want to upload
        let riversRef = Firebase.storageData.reference().child("\(uuid).jpeg")
        
        guard let data = selectedImg.jpegData(compressionQuality: 0.4) else {
            return
        }

        // Upload the file to the path "images/rivers.jpg"
        _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard url != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
                self.selectedImages.append(url!.absoluteString)
            }
        }.resume()
        selectedImgs.append(selectedImg)
        colVwImages.reloadData()
    }
}

//extension CreateVC: CardIOPaymentViewControllerDelegate {
//    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
//        paymentViewController?.dismiss(animated: true, completion: nil)
//    }
//
//    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
//        if let info = cardInfo {
//            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
//            txtFldCardNo.text = info.cardNumber
//            txtFldNameOnCard.text = info.cardholderName
//            txtFldCVV.text = info.cvv
//            txtFldExpDate.text = "\(info.expiryMonth)/\(info.expiryYear)"
//        }
//        paymentViewController?.dismiss(animated: true, completion: nil)
//    }
//
//}

extension CreateVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lblAddImages.isHidden = selectedImgs.count > 0
        return selectedImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imgVw.image = selectedImgs[indexPath.row]
        return cell
    }    
}
