

import UIKit
import NVActivityIndicatorView

class SaveBankAcntVC: UIViewController, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var txtFldScreenName: UITextField!
    @IBOutlet weak var txtFldBankName: UITextField!
    @IBOutlet weak var txtFldAcntHolderName: UITextField!
    @IBOutlet weak var txtFldIFSC: UITextField!
    @IBOutlet weak var txtFldAcntNo: UITextField!
    @IBOutlet weak var txtFldBranchName: UITextField!
    @IBOutlet weak var txtVwAdditionalInfo: UITextView!
    @IBOutlet weak var lblNoRecords: UILabel!
    @IBOutlet weak var colVwImages: UICollectionView!
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
            "type" : "bank",
            "0" : txtFldScreenName.text!,
            "1" : txtFldBankName.text!,
            "2" : txtFldAcntHolderName.text!,
            "3" : txtFldIFSC.text!,
            "4" : txtFldAcntNo.text!,
            "5" : txtFldBranchName.text!,
            "6" : txtVwAdditionalInfo.text!,
            "images" : selectedImages
            ] as [String : Any]
        startAnimating()
        Firebase.userRef.document(UserDefaults.standard.value(forKey: "userID") as! String).collection("documents").document(txtFldScreenName.text!).setData(param as [String : Any], completion: { (error) in
            if error != nil {
                toastMessage("Something went wrong, please try again later")
                return
            }
            self.stopAnimating()
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
}

extension SaveBankAcntVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lblNoRecords.isHidden = selectedImgs.count > 0
        return selectedImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imgVw.image = selectedImgs[indexPath.row]
        return cell
    }
}

extension SaveBankAcntVC: ImageSelected {
    func finishPassing(selectedImg: UIImage) {
        let uuid = UUID().uuidString
        // Create a reference to the file you want to upload
        let riversRef = Firebase.storageData.reference().child("\(uuid).jpeg")
        
        guard let data = selectedImg.jpegData(compressionQuality: 0.4) else {
            return
        }
        startAnimating()
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
        stopAnimating()
    }
}
