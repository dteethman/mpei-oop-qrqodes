import UIKit

class QRSaverView: UIViewController {
    private(set) var codeViewModel: QRCodeViewModel
    private(set) var libraryViewModel: LibraryViewModel
    
    var iconImageView: UIImageView!
    var qrTextView: UITextView!
    var titleTextField: UITextField!
    var descriptionTextView: UITextView!
    var saveButton: UIButton!
    
    var dismissKeyboardGR: UITapGestureRecognizer!
    
    let descriptionPlaceholderString = "Description (optional)"
    
    init(codeViewModel: QRCodeViewModel, libraryViewModel: LibraryViewModel) {
        self.codeViewModel = codeViewModel
        self.libraryViewModel = libraryViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setCodeInfo()
        setAppearance(isDarkMode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        codeViewModel.bind { code in
            self.updateButtonState(code: code)
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setAppearance(isDarkMode)
    }
    
    @objc func dismissKeyboard(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func saveAction(_ sender: UIButton!) {
        if codeViewModel.code != nil && codeViewModel.code?.stringValue != nil {
            dismiss(animated: true) {
                self.libraryViewModel.save(code: self.codeViewModel.code!)
            }
        }
        
    }
    
    
}
