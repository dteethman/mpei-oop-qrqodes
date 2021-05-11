import UIKit
import CoreData

class LibraryViewController: UIViewController {
    //MARK: - Variables
    var newScanButton: UIButton!
    var codesTableView: UITableView!
    
    var observer: NSKeyValueObservation?
    
    lazy var qrData: [(qr: QRCode, id: NSManagedObjectID)]! = nil {
        didSet {
            codesTableView?.reloadData()
//            codesTableView?.layoutSubviews()
            for d in qrData {
                print(d.qr.title)
            }
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

