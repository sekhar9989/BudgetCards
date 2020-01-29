
import UIKit

class SelectTypeVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnAadhar: MyButton!
    @IBOutlet weak var btncredit: MyButton!
    @IBOutlet weak var btnBank: MyButton!
    @IBOutlet weak var btnPassport: MyButton!
    @IBOutlet weak var btnVisitingCard: MyButton!
    @IBOutlet weak var btnPAN: MyButton!
    @IBOutlet weak var btnVoterID: MyButton!
    @IBOutlet weak var btnOther: MyButton!
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        btnAadhar.addShadow(shadowColor: AppColors.blueBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btncredit.addShadow(shadowColor: AppColors.blueBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnBank.addShadow(shadowColor: AppColors.blueBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnPassport.addShadow(shadowColor: AppColors.blueBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnVisitingCard.addShadow(shadowColor: AppColors.blueBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnPAN.addShadow(shadowColor: AppColors.blueBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnVoterID.addShadow(shadowColor: AppColors.blueBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)
        btnOther.addShadow(shadowColor: AppColors.blueBorder.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 1, shadowRadius: 10)

    }
    
    override func viewDidAppear(_ animated: Bool) {

        
    }
    
    //MARK:- IBActions
    @IBAction func acionback(_ sender: Any) {
        popToBack()
    }
    
    @IBAction func actionAadhar(_ sender: Any) {
        pushTo(VC: "SaveAadharVC")
    }
    
    @IBAction func actionCreditCard(_ sender: Any) {
        pushTo(VC: "CreateVC")
    }
    
    @IBAction func actionBankAcnt(_ sender: Any) {
        pushTo(VC: "SaveBankAcntVC")
    }
    
    @IBAction func actionPassport(_ sender: Any) {
        pushTo(VC: "SavePassportVC")
    }
    
    @IBAction func actionVisitingCard(_ sender: Any) {
        pushTo(VC: "SaveVisitingCardVC")
    }
    
    
    @IBAction func actionPanCard(_ sender: Any) {
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SaveOtherVC") as! SaveOtherVC
        nextVc.headerType = "Pancard"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @IBAction func actionVoterID(_ sender: Any) {
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SaveOtherVC") as! SaveOtherVC
        nextVc.headerType = "Voter ID"
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    
    @IBAction func actionOther(_ sender: Any) {
        pushTo(VC: "SaveOtherVC")
    }
}
