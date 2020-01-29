

import UIKit
import NVActivityIndicatorView

class ListVC: UIViewController,NVActivityIndicatorViewable {
    
    //MARK:- Outlets
    @IBOutlet weak var tblVwList: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwBagroundMoreButtons: UIView!
    @IBOutlet var btnMore : UIButton!
    @IBOutlet var lblTotalAmount : UILabel!
    
    //MARK:- Variables and Constants
    var arrSelected = [[String:Any]]()
    var arrExpenditure = [[String:Any]]()
    var arrIncome = [[String:Any]]()
    var arrTotalData = [[String:Any]]()
    
    var selectedList = Int()
    var allSelected = false
    let arrType = ["Income","Expenditure"]
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    //MARK:- Custom Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        vwBagroundMoreButtons.isHidden = true
        btnMore.isSelected = false
    }
    
    func getData() {
        startAnimating()
        Firebase.userRef.document(UserDefaults.standard.value(forKey: "userID") as! String).collection("Transactions").getDocuments { (querySnapshot, error) in
            if error != nil {
                toastMessage( error?.localizedDescription ?? "Something went wrong, please try again later")
            } else {
                guard let snapshot = querySnapshot else {
                    return
                }
                self.arrExpenditure.removeAll()
                self.arrIncome.removeAll()
                self.arrTotalData.removeAll()
                
                let documents = snapshot.documents
                for document in documents {
                    if document.data()["type"] as! String == self.arrType[0] {
                        self.arrIncome.append(document.data())
                    } else {
                        self.arrExpenditure.append(document.data())
                    }
                    self.arrTotalData.append(document.data())
                }
                self.tblVwList.reloadData()
            }
            self.updateData()
            self.stopAnimating()
        }
    }
    
    func updateData() {
        switch selectedList {
        case 0:
            arrSelected = arrExpenditure
        case 1:
            arrSelected = arrIncome
        case 2:
            arrSelected = arrTotalData
        default:
            break
        }
        arrSelected.sort { getDate(str: $0["date"]! as! String)! > getDate(str: $1["date"]! as! String)!}
        tblVwList.reloadData()
        if allSelected {
            showRemainingBal()
        } else {
            showTotal()
        }
    }
    
    func changeList(arr: [[String:Any]], text: String) {
        arrSelected = arr
        arrSelected.sort { getDate(str: $0["date"]! as! String)! > getDate(str: $1["date"]! as! String)!}
        lblHeader.text = text
        tblVwList.reloadData()
    }
    
    func filterData() {
        vwBagroundMoreButtons.isHidden = true
        btnMore.isSelected = false
        viewWillAppear(true)
    }
    
    func showTotal() {
        let total = arrSelected.compactMap{ Int(($0["amount"] as? String)!)}.reduce(0, +)
        lblTotalAmount.text = "\(total)"
    }
    
    func showRemainingBal() {
        var arrIncome = [[String:Any]]()
        var arrExpenditures = [[String:Any]]()
        for i in 0..<arrSelected.count {
            switch arrSelected[i]["type"] as! String {
            case arrType[0] :
                arrIncome.append(arrSelected[i])
            case arrType[1] :
                arrExpenditures.append(arrSelected[i])
            default:
                break
            }
        }
        let totalIncome = arrIncome.compactMap{ Int(($0["amount"] as? String)!)}.reduce(0, +)
        let totalExpends = arrExpenditures.compactMap{ Int(($0["amount"] as? String)!)}.reduce(0, +)
        let balance = totalIncome - totalExpends
        if balance > 0 {
            lblTotalAmount.textColor = .green
        } else {
            lblTotalAmount.textColor = .red
        }
        lblTotalAmount.text = "\(balance)"
    }
    
    //MARK:- IBActions
    @IBAction func actionPlus(_ sender: Any) {
        pushTo(VC: "CreateBudgetVC")
    }
    
    @IBAction func actionMore(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            vwBagroundMoreButtons.isHidden = false
        } else {
            sender.isSelected = false
            vwBagroundMoreButtons.isHidden = true
        }
    }
    
    @IBAction func action1Day(_ sender: Any) {
        filterData()
        arrSelected.removeAll {(Date().timeIntervalSince(getDate(str: $0["date"] as! String)!)) > 86400}
        tblVwList.reloadData()
        if allSelected {
            showRemainingBal()
        } else {
            showTotal()
        }
    }
    
    @IBAction func action7Days(_ sender: Any) {
        filterData()
        arrSelected.removeAll {(Date().timeIntervalSince(getDate(str: $0["date"] as! String)!)) > 86400*7}
        tblVwList.reloadData()
        if allSelected {
            showRemainingBal()
        } else {
            showTotal()
        }
    }
    
    @IBAction func action30Days(_ sender: Any) {
        filterData()
        arrSelected.removeAll {(Date().timeIntervalSince(getDate(str: $0["date"] as! String)!)) > 86400*30}
        tblVwList.reloadData()
        if allSelected {
            showRemainingBal()
        } else {
            showTotal()
        }
    }
    
    @IBAction func actionAllTransactions(_ sender: Any) {
        filterData()
        if allSelected {
            showRemainingBal()
        } else {
            showTotal()
        }
    }
    
    @IBAction func actionExpenditures(_ sender: UIButton) {
        allSelected = false
        selectedList = 0
        changeList(arr: arrExpenditure, text: "Expenditures")
        showTotal()
        lblTotalAmount.textColor = .red
    }
    
    @IBAction func actionIncome(_ sender: UIButton) {
        allSelected = false
        selectedList = 1
        changeList(arr: arrIncome, text: "Income")
        showTotal()
        lblTotalAmount.textColor = .green
    }
    
    @IBAction func actionAll(_ sender: UIButton) {
        allSelected = true
        selectedList = 2
        changeList(arr: arrTotalData, text: "All Transactions")
        showRemainingBal()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        popToBack()
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSelected.count > 0 {
            tblVwList.backgroundView = nil
        } else {
            let noRecords = UINib(nibName: "NoRecords", bundle: .main).instantiate(withOwner: nil, options: nil).first as? NoRecords
            noRecords?.lbl.text = "No transactions found in this category, Click on '+' to add transactions"
            noRecords?.imgVw.tintColor = .lightGray
            noRecords?.imgVw.image = #imageLiteral(resourceName: "transaction")
            noRecords?.frame = tblVwList.bounds
            tblVwList.backgroundView = noRecords
        }
        return arrSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVC", for: indexPath) as! ListTVC
        let dict = arrSelected[indexPath.row]
        var strValue = "-"
        if dict["type"] as! String == "Income" {
            strValue = "+"
            cell.lblAmount.textColor = .green
        } else {
            strValue = "-"
            cell.lblAmount.textColor = .red
        }
        cell.lblAmount.text = "\(strValue) \(dict["amount"] as! String) - \(dict["source"]!)"
        cell.lblDate.text = dict["date"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FullDetailsVC") as! FullDetailsVC
        nextVC.dict = arrSelected[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:@escaping (Bool) -> Void) in
            let dict = self.arrSelected[indexPath.row]
            self.startAnimating()
            Firebase.userRef.document(UserDefaults.standard.value(forKey: "userID") as! String).collection("Transactions").document(dict["id"] as! String).delete(completion: { (error) in
                if error != nil {
                    toastMessage( error?.localizedDescription ?? "Something went wrong, please try again later")
                    return
                } else {
                    self.viewWillAppear(true)
                    success(true)
                }
            })
            self.stopAnimating()
        })
        modifyAction.image = UIImage(named: "bin")
        modifyAction.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.662745098, blue: 0.6509803922, alpha: 1)
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
}
