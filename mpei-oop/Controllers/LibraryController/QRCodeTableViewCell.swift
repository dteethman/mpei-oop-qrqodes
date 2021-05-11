import UIKit

class QRCodeTableViewCell: UITableViewCell {
    var qr: QRCode! {
        didSet {
            if qr is WiFiQRCode {
                typeImageView?.image = .init(systemName: "wifi")
            } else {
                typeImageView?.image = .init(systemName: "qrcode")
            }
            
            if let title = qr?.title {
                titleLabel?.text = title
            }
            
            if let description = qr?.description {
                descriptionTextView?.text = description
            }
        }
    }
    private var typeImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionTextView: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        typeImageView = UIImageView()
        typeImageView.translatesAutoresizingMaskIntoConstraints = false
        typeImageView.contentMode = .scaleAspectFit
        typeImageView.backgroundColor = .clear
        self.addSubview(typeImageView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .clear
        self.addSubview(titleLabel)
        
        descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textColor = .secondaryLabel
        self.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            typeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            typeImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            typeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            typeImageView.widthAnchor.constraint(equalTo: typeImageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: typeImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            descriptionTextView.bottomAnchor.constraint(equalTo: typeImageView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for reuse")
        typeImageView?.image = nil
        titleLabel?.text = nil
        descriptionTextView?.text = nil
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        imageView?.layoutSubviews()
    }
}
