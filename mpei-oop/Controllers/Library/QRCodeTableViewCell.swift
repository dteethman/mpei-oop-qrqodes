import UIKit

class QRCodeTableViewCell: UITableViewCell {
    var qr: QRCode! {
        didSet {
            if qr is WiFiQRCode {
                tImageView?.image = .init(systemName: "wifi")
            } else {
                tImageView?.image = .init(systemName: "qrcode")
            }
            
            if let title = qr?.title {
                titleLabel?.text = title
            }
            
            if let description = qr?.description {
                descriptionTextView?.text = description
            }
        }
    }
    private var tImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionTextView: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        tImageView = UIImageView()
        tImageView.translatesAutoresizingMaskIntoConstraints = false
        tImageView.contentMode = .scaleAspectFit
        tImageView.backgroundColor = .clear
        self.addSubview(tImageView)
        
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
            tImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            tImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            tImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tImageView.widthAnchor.constraint(equalTo: tImageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: tImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: tImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            descriptionTextView.bottomAnchor.constraint(equalTo: tImageView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tImageView?.image = nil
        titleLabel?.text = nil
        descriptionTextView?.text = nil
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        imageView?.layoutSubviews()
    }
}
