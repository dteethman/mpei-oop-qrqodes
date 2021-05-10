import UIKit

extension QRSaverViewController {
    func setupLayout() {
        let safeGuide = view.safeAreaLayoutGuide
        
        self.title = "New QR"
        
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        self.view.addSubview(iconImageView)
        
        qrTextField = UITextView()
        qrTextField.translatesAutoresizingMaskIntoConstraints = false
        qrTextField.isEditable = false
        qrTextField.isSelectable = false
        qrTextField.backgroundColor = .clear
        self.view.addSubview(qrTextField)
    
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalTo: safeGuide.widthAnchor, multiplier: 0.25),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            qrTextField.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            qrTextField.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            qrTextField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            qrTextField.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -16),
        ])
        
    }
    
    func updateLayout() {
        if qr is WiFiQRCode {
            iconImageView?.image = .init(systemName: "wifi")
        } else {
            iconImageView?.image = .init(systemName: "qrcode")
        }
        
        qrTextField?.attributedText = qr?.getInfo()
    }
    
    func setApperance(_ isDarkMode: Bool) {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
    }
}
