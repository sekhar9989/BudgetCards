

import UIKit
import NVActivityIndicatorView

class HomeVC: UIViewController, NVActivityIndicatorViewable {
    
    //MARK:- Outlets
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: RoundedView!
    @IBOutlet weak var btnPlus: MyButton!
    
    var arrDocumetns = [[String:Any]]()

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            vwTop.layer.cornerRadius = 25
            vwTop.layer.masksToBounds = true
            vwTop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startAnimating()
        Firebase.userRef.document(UserDefaults.standard.value(forKey: "userID") as! String).collection("documents").getDocuments { (querySnapshot, error) in
            if error != nil {
                toastMessage(error?.localizedDescription ?? "Something went wrong, please try later")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                self.arrDocumetns.removeAll()
                let documents = snapshot.documents
                for document in documents {
                    self.arrDocumetns.append(document.data())
                }
                self.tblVw.reloadData()
            }
            self.stopAnimating()
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionAddNew(_ sender: Any) {
        pushTo(VC: "SelectTypeVC")
    }
    
    @IBAction func actionSettings(_ sender: Any) {
        pushTo(VC: "SettingsVC")
    }
    
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrDocumetns.count > 0 {
            tblVw.backgroundView = nil
        } else {
            let noRecords = UINib(nibName: "NoRecords", bundle: .main).instantiate(withOwner: nil, options: nil).first as? NoRecords
            noRecords?.lbl.text = "No documents found, Click on '+' to add documents\n ↓ "
            noRecords?.imgVw.tintColor = .lightGray
            noRecords?.imgVw.image = #imageLiteral(resourceName: "folder")
            noRecords?.frame = tblVw.bounds
            tblVw.backgroundView = noRecords
        }
        return arrDocumetns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        let document = arrDocumetns[indexPath.row]
        cell.lblName.text = document["0"] as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        nextVC.detail = arrDocumetns[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let dict = self.arrDocumetns[indexPath.row]
            self.startAnimating()
            Firebase.userRef.document(UserDefaults.standard.value(forKey: "userID") as! String).collection("documents").document(dict["0"] as! String).delete() { err in
                if let err = err {
                    toastMessage("Error removing document: \(err.localizedDescription)")
                } else {
                    toastMessage("Document successfully removed!")
                }
            }
            self.stopAnimating()
            self.viewWillAppear(true)
            success(true)
        })
        modifyAction.image = UIImage(named: "bin")
        modifyAction.backgroundColor = #colorLiteral(red: 0.8026530743, green: 0.3070376708, blue: 0.6005180159, alpha: 1)
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}
