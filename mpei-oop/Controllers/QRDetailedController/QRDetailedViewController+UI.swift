import UIKit

extension QRDetailedViewController {
    func setupLayout() {
        let safeGuide = view.safeAreaLayoutGuide
        
        qrImageView = UIImageView()
        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        qrImageView.contentMode = .scaleAspectFit
        qrImageView.backgroundColor = .red
        self.view.addSubview(qrImageView)
        
        qrTextView = UITextView()
        qrTextView.translatesAutoresizingMaskIntoConstraints = false
        qrTextView.isEditable = false
        qrTextView.isSelectable = false
        qrTextView.backgroundColor = .clear
        qrTextView.textContainerInset = .zero
        qrTextView.textContainer.lineFragmentPadding = 0
        self.view.addSubview(qrTextView)
        
        deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.layer.cornerRadius = 8
        deleteButton.layer.cornerCurve = .continuous
        deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        self.view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -28),
            deleteButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 36),
            deleteButton.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -36),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
            qrImageView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 20),
            qrImageView.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            qrImageView.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            qrImageView.heightAnchor.constraint(equalTo: qrImageView.widthAnchor),

            qrTextView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 20),
            qrTextView.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            qrTextView.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            qrTextView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -30),
        ])
        
        if let image = qrData?.qr.getImage() {
            qrImageView?.image = image
        }
        
        if let text = qrData?.qr.getInfo() {
            qrTextView.attributedText = text
        }
        
        if let title = qrData?.qr.title {
            self.title = title
        }
    }
    
    func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setAppearance(_ isDarkMode: Bool) {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        deleteButton?.backgroundColor = .systemRed
        deleteButton?.titleLabel?.textColor = .white
        
        qrImageView?.layer.borderWidth = isDarkMode ? 0 : 1
        qrImageView?.layer.borderColor = UIColor.systemGray5.cgColor
    }
}
