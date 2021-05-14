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
    
    var onDismissAction: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        updateLayout()
        setAppearance(isDarkMode)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setAppearance(isDarkMode)
    }
    
    @objc func dismissKeyboard(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
        setAppearance(isDarkMode)
    }
    
    @objc func saveAction(_ sender: UIButton!) {
        let cdManager = QRDataManager()
        if qr?.title != nil && qr?.stringValue != nil {
            cdManager.save(qr: qr!)
            dismiss(animated: true) {
                self.onDismissAction?()
            }
        }
        
    }
    
    
}
