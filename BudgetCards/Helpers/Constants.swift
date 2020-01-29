

import UIKit
import Firebase
import FirebaseStorage

struct Firebase {
    static let db = Firestore.firestore()
    static let storage = Storage.storage()
    static let userRef = Firestore.firestore().collection("Users")
    static let storageData = Storage.storage(url:"gs://secards-37bd2.appspot.com/")
}

struct AppColors {
    static let purpleBorder = UIColor(red: 205/255, green: 78/255, blue: 153/255, alpha: 1)
    static let blueBorder = UIColor(red: 104/255, green: 166/255, blue: 214/255, alpha: 1)
}
