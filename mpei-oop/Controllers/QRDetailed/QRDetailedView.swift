import UIKit
import CoreData

class QRDetailedView: UIViewController {
    //MARK:- Variables
    private(set) var viewModel: LibraryViewModel
    private(set) var index: Int
    
    var qrImageView: UIImageView!
    var qrTextView: UITextView!
    var deleteButton: UIButton!
    
    init(viewModel: LibraryViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupLayout()
        updateLayout(code: viewModel.library?[index].code)
        setAppearance(isDarkMode)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setAppearance(isDarkMode)
    }
    
    //MARK:- Controls actions
    @objc func deleteAction(_ sender: UIControl) {
        if let id = viewModel.library?[index].id {
            viewModel.delete(id: id)
        }
        navigationController?.popViewController(animated: true)
    }
}
