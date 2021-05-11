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
            qrImageView.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 20),
            qrImageView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 16),
            qrImageView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -16),
            qrImageView.heightAnchor.constraint(equalTo: qrImageView.widthAnchor),
            
            deleteButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -28),
            deleteButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 36),
            deleteButton.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -36),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
            qrTextView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 20),
            qrTextView.leadingAnchor.constraint(equalTo: qrImageView.leadingAnchor),
            qrTextView.trailingAnchor.constraint(equalTo: qrImageView.trailingAnchor),
            qrTextView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -30),
        ])
        
        if let image = qrData.qr.getImage() {
            qrImageView?.image = image
        }
        
        if let text = qrData?.qr.getInfo() {
            qrTextView.attributedText = text
        }
    }
    
    func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setAppearance(_ isDarkMode: Bool) {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        deleteButton?.backgroundColor = .systemRed
        deleteButton?.titleLabel?.textColor = .white
    }
}
