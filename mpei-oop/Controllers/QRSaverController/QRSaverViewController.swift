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
    var qrTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setApperance(isDarkMode)
        setupLayout()
        updateLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance(isDarkMode)
    }
    
    
    
}
