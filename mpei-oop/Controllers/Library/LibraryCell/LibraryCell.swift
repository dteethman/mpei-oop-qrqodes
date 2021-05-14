import UIKit

class LibraryCell: UITableViewCell {
    private(set) var viewModel: LibraryViewModel?
    private var index: Int?
    
    private var typeImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionTextView: UITextView!
    
    func update(viewModel: LibraryViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
        
        setupLayout()
        
        if let library = viewModel.library {
            if library[index].code is WiFiQRCode {
                self.typeImageView?.image = .init(systemName: "wifi")
            } else {
                self.typeImageView?.image = .init(systemName: "qrcode")
            }
            self.titleLabel?.text = library[index].code.title
            self.descriptionTextView?.text = library[index].code.description
        }
    }
    
    func setupLayout() {
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
    override func prepareForReuse() {
        super.prepareForReuse()
        typeImageView?.image = nil
        titleLabel?.text = nil
        descriptionTextView?.text = nil
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        imageView?.layoutSubviews()
    }
}
