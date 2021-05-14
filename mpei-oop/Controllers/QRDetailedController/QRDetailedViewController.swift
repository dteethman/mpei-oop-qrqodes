import UIKit
import CoreData

class QRDetailedViewController: UIViewController {
    //MARK:- Variables
    var qrImageView: UIImageView!
    var qrTextView: UITextView!
    var deleteButton: UIButton!
    
    var qrData: (code: QRCode, id: NSManagedObjectID)! 
    
    var onDismissAction: (() -> Void)!
    
    //MARK:- Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupLayout()
        setAppearance(isDarkMode)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setAppearance(isDarkMode)
    }
    
    //MARK:- Controls actions
    @objc func deleteAction(_ sender: UIControl) {
        onDismissAction()
        navigationController?.popViewController(animated: true)
    }
}
