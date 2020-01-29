

import UIKit
import SDWebImage

class DetailsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblVwDetails: UITableView!
    @IBOutlet weak var colVwDetails: UICollectionView!
    
    //MARK:- Variables
    var detail = [String:Any]()
    var arrImages = [String]()
    var arrKeys = [String]()
    var arrValues = [String]()
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let images = detail["images"] as? NSArray {
            for image in images {
                if let imageLink = image as? String {
                    if !imageLink.isEmpty {
                        arrImages.append(imageLink)
                    }
                }
            }
            colVwDetails.reloadData()
        }
        
        switch detail["type"] as! String {
        case "card":
            arrKeys = ["ScreeningName","Name on card","CardNumber","Expiry date","CVV","PIN","Additionl info"]
        case "bank" :
            arrKeys = ["ScreeningName","Bank name","Account holder name","IFSC code","Account number","Branch name","Additional info"]
        case "aadhar":
            arrKeys = ["ScreeningName","Full name","S/O W/O","Aadhar No","Address","Additional info"]
        case "visiting":
            arrKeys = ["ScreeningName","Name","Phone No","Email","Additional info"]
        case "passport" :
            arrKeys = ["ScreeningName","Full name","S/O W/O","Passport No","Address","Additional info"]
        default:
            arrKeys = ["ScreeningName","Name","Number","Additional info"]
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
}

extension DetailsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCVC", for: indexPath) as! DetailsCVC
        cell.imgVw.sd_setImage(with: URL(string: arrImages[indexPath.row]), placeholderImage: #imageLiteral(resourceName: "folder"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colVwDetails.frame.width, height: colVwDetails.frame.height)
    }
}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail.count - 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTVC", for: indexPath) as! DetailsTVC
        cell.lblKey.text = arrKeys[indexPath.row]
        cell.txtVwvalue.text = detail["\(indexPath.row)"] as? String
        return cell
    }    
}
