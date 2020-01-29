

import UIKit
import NVActivityIndicatorView

class SavePassportVC: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var txtFldScreenName: UITextField!
    @IBOutlet weak var txtFldFullName: UITextField!
    @IBOutlet weak var txtFldSonOf: UITextField!
    @IBOutlet weak var txtFldPassport: UITextField!
    @IBOutlet weak var txtFldExpiry: UITextField!
    @IBOutlet weak var txtVwAddress: UITextView!
    @IBOutlet weak var txtVwAdditional: UITextView!
    @IBOutlet weak var lblAddImages: UILabel!
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
            "type" : "passport",
            "0" : txtFldScreenName.text!,
            "1" : txtFldFullName.text!,
            "2" : txtFldSonOf.text!,
            "3" : txtFldPassport.text!,
            "4" : txtVwAddress.text!,
            "5" : txtVwAdditional.text!,
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

extension SavePassportVC: UICollectionViewDataSource, UICollectionViewDelegate {
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

extension SavePassportVC: ImageSelected {
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
