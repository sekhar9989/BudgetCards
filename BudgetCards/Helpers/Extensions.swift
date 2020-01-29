

import UIKit

extension UIViewController {
    func pushTo(VC: String) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: VC)
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    func popToBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

@IBDesignable class MyLable :  UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    override var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

extension UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.4
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.2, height: 0.2),
                   shadowOpacity: Float = 0.8,
                   shadowRadius: CGFloat = 4) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func dropshaow() {
        layer.shadowOpacity = 1.0
    }
    
    func rounded() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func addGradiantColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor,#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).cgColor,#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1).cgColor]
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        //Use diffrent colors
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}

@IBDesignable class MyButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    override var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

@IBDesignable class RoundedView: UIView
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}

@IBDesignable class ShadowView : UIView {
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var shadowColor : UIColor? {
        didSet{
            setAttributes()
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 0 {
        didSet{
            setAttributes()
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 0 {
        didSet{
            setAttributes()
        }
    }
    
    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0) {
        didSet{
            setAttributes()
        }
    }
    
    @IBInspectable var shadowCornerRadius : CGFloat = 0 {
        didSet{
            setAttributes()
        }
    }
    
    func setAttributes() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.cornerRadius = shadowCornerRadius
    }
}

@IBDesignable class ShadowButton : UIButton {
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var shadowColor : UIColor? {
        didSet{
            setAttributes()
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 0 {
        didSet{
            setAttributes()
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 0 {
        didSet{
            setAttributes()
        }
    }
    
    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0) {
        didSet{
            setAttributes()
        }
    }
    
    @IBInspectable var shadowCornerRadius : CGFloat = 0 {
        didSet{
            setAttributes()
        }
    }
    
    func setAttributes() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.cornerRadius = shadowCornerRadius
    }
}

@IBDesignable class RoundedImage: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    
    @IBInspectable
    override var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    override var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

func getDate(str:String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy  hh:mm a"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: str) // replace Date String
}

func ConvertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
}

func ConvertBase64StringToImage (imageBase64String:String) -> UIImage {
    let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
    let image = UIImage(data: imageData!)
    return image!
}

func toastMessage(_ message: String){
    guard let window = UIApplication.shared.keyWindow else {return}
    let messageLbl = UILabel()
    messageLbl.text = message
    messageLbl.textAlignment = .center
    messageLbl.font = UIFont.systemFont(ofSize: 12)
    messageLbl.textColor = .white
    messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)
    
    let textSize:CGSize = messageLbl.intrinsicContentSize
    let labelWidth = min(textSize.width, window.frame.width - 40)
    
    messageLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
    messageLbl.center.x = window.center.x
    messageLbl.layer.cornerRadius = messageLbl.frame.height/2
    messageLbl.layer.masksToBounds = true
    window.addSubview(messageLbl)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        
        UIView.animate(withDuration: 2, animations: {
            messageLbl.alpha = 0
        }) { (_) in
            messageLbl.removeFromSuperview()
        }
    }
}

extension UITextField {
    func goToNextTextField(_ txtFld: UITextField) {
        self.resignFirstResponder()
        txtFld.becomeFirstResponder()
    }
}

// An attributed string extension to achieve colors on text.
extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}

func isValidEmail(emailStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: emailStr)
}

extension UINavigationController {
    func backToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
