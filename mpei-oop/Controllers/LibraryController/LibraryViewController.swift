import UIKit
import CoreData

class LibraryViewController: UITableViewController {
    //MARK: - Variables
    var newScanButton: UIButton!
//    var codesTableView: UITableView!
    
    var observer: NSKeyValueObservation?
    
    lazy var qrData: [(qr: QRCode, id: NSManagedObjectID)]! = nil {
        didSet {
            tableView?.reloadData()
            tableView?.layoutSubviews()
        }
    }
    
    //MARK: - ViewControllerLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setAppearance()
        setupNavBar()
        
        
        CoreDataManager().loadAsync { result in
            self.qrData = result
        }
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
            CoreDataManager().loadAsync { result in
                self.qrData = result
            }
        }
        
        let scaner = UINavigationController(rootViewController: scanerController)
        scaner.modalPresentationStyle = .fullScreen
        self.present(scaner, animated: true, completion: nil)
    }
    

}

