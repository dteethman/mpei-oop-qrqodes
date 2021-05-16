import UIKit
import CoreData

class LibraryView: UITableViewController {
    //MARK: - Variables
    private(set) var viewModel: LibraryViewModel
    
    var newScanButton: UIButton!
    
    var observer: NSKeyValueObservation?
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bind { libraryItems in
            self.tableView.reloadData()
            self.tableView.layoutSubviews()
        }
        
        setupLayout()
        setAppearance()
        setupNavBar()
        
        viewModel.loadLibrary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newScanButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newScanButton.isHidden = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
    }
    
    //MARK: - Button actions
    @objc func scanAction(_ sender: UIButton!) {
        let codeViewModel = QRCodeViewModel()
        let scanerController = QRScanerView(codeViewModel: codeViewModel, libraryViewModel: self.viewModel)
        
        let scaner = UINavigationController(rootViewController: scanerController)
        scaner.modalPresentationStyle = .fullScreen
        self.present(scaner, animated: true, completion: nil)
    }
    

}

