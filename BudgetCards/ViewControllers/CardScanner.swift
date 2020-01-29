
import UIKit
//import PayCardsRecognizer

class CardScanner: UIViewController {
    
//    var recognizer: PayCardsRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        recognizer = PayCardsRecognizer(delegate: self, resultMode: .sync, container: self.view, frameColor: .green)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        recognizer.startCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        recognizer.stopCamera()
    }
    
    // PayCardsRecognizerPlatformDelegate
    
//    func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
//        if result.isCompleted {
//            toastMessage( result.recognizedNumber!) // Card number
//            toastMessage(result.recognizedHolderName!) // Card holder
//            toastMessage(result.recognizedExpireDateMonth!) // Expire month
//            toastMessage(result.recognizedExpireDateYear!) // Expire year
//            self.dismiss(animated: true, completion: nil)
////            performSegue(withIdentifier: "CardDetailsViewController", sender: result)
//
//        } else {
////            navigationItem.rightBarButtonItem = activityView
//        }
//
//    }
    
}

//extension CardScanner: PayCardsRecognizerPlatformDelegate {
//
//}
