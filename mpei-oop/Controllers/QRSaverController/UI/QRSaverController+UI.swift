import UIKit

extension QRSaverViewController {
    func setupLayout() {
        let safeGuide = view.safeAreaLayoutGuide
        
        self.title = "New QR"
        
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        self.view.addSubview(iconImageView)
        
        qrTextView = UITextView()
        qrTextView.translatesAutoresizingMaskIntoConstraints = false
        qrTextView.isEditable = false
        qrTextView.isSelectable = false
        qrTextView.backgroundColor = .clear
        self.view.addSubview(qrTextView)
        
        dismissKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_ :)))
        self.view.addGestureRecognizer(dismissKeyboardGR)
        
        titleTextField = UITextField()
        titleTextField.delegate = self
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "Add title"
        titleTextField.font = .systemFont(ofSize: 17, weight: .semibold)
        self.view.addSubview(titleTextField)
        
        descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.delegate = self
        descriptionTextView.backgroundColor = .clear
        descriptionTextView?.textColor = .tertiaryLabel
        descriptionTextView.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionTextView.text = descriptionPlaceholderString
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        self.view.addSubview(descriptionTextView)
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitle("Save", for: .disabled)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.layer.cornerRadius = 8
        saveButton.layer.cornerCurve = .continuous
        saveButton.addTarget(self, action: #selector(saveAction(_:)), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalTo: safeGuide.widthAnchor, multiplier: 0.25),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            qrTextView.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            qrTextView.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            qrTextView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            qrTextView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -16),
            
            titleTextField.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: qrTextView.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalTo: titleTextField.heightAnchor, multiplier: 3),
            
            saveButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -28),
            saveButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 36),
            saveButton.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -36),
            saveButton.heightAnchor.constraint(equalToConstant: 50),

        ])
        
    }
    
    func updateLayout() {
        if qr is WiFiQRCode {
            iconImageView?.image = .init(systemName: "wifi")
        } else {
            iconImageView?.image = .init(systemName: "qrcode")
        }
        
        qrTextView?.attributedText = qr?.getInfo()
        if qr?.title == nil || qr?.title == "" {
            saveButton?.isEnabled = false
        } else {
            saveButton?.isEnabled = true
        }
    }
    
    func setAppearance(_ isDarkMode: Bool) {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        saveButton?.backgroundColor = saveButton?.isEnabled ?? false ? .systemBlue : .systemGray2
    }
}
