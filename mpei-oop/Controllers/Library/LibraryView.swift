import UIKit
import CoreData

class LibraryView: UITableViewController {
    //MARK: - Variables
    private(set) var viewModel: LibraryViewModel?
    
    var newScanButton: UIButton!
    
    var observer: NSKeyValueObservation?
    
//    lazy var qrData: [(qr: QRCode, id: NSManagedObjectID)]! = nil {
//        didSet {
//            tableView?.reloadData()
//            tableView?.layoutSubviews()
//        }
//    }
    
    //MARK: - ViewControllerLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataManager = QRDataManager()
        viewModel = LibraryViewModel(dataManager: dataManager)
        
        viewModel?.library.bind(listener: { libraryItems in
            self.tableView.reloadData()
            self.tableView.layoutSubviews()
        })
        
        setupLayout()
        setAppearance()
        setupNavBar()
        
        viewModel?.loadLibrary()
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
        let scanerController = QRScanerViewController()
        scanerController.onDismissAction = {
            QRDataManager().loadAsync { result in
                self.viewModel?.loadLibrary()
            }
        }
        
        let scaner = UINavigationController(rootViewController: scanerController)
        scaner.modalPresentationStyle = .fullScreen
        self.present(scaner, animated: true, completion: nil)
    }
    

}

