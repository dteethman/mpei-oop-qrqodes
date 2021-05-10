import UIKit

class QRSaverViewController: UIViewController {
    var qr: QRCode? {
        didSet {
            if qr?.stringValue != nil {
                if qr!.stringValue.hasPrefix("WIFI:") {
                    let wifiqr = WiFiQRCode(stringValue: qr!.stringValue)
                    if wifiqr.ssid != nil {
                        qr = wifiqr
                    }
                }
            }
            
            updateLayout()
        }
    }
    
    var iconImageView: UIImageView!
    var qrTextView: UITextView!
    var titleTextField: UITextField!
    var descriptionTextView: UITextView!
    var saveButton: UIButton!
    
    var dismissKeyboardGR: UITapGestureRecognizer!
    
    let descriptionPlaceholderString = "Description (optional)" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        updateLayout()
        setApperance(isDarkMode)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance(isDarkMode)
    }
    
    @objc func dismissKeyboard(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
        setApperance(isDarkMode)
    }
    
    @objc func saveAction(_ sender: UIButton!) {
        print(qr?.title, qr?.description, qr?.stringValue)
    }
    
    
}
