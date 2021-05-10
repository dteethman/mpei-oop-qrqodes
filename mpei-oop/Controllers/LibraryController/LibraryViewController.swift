import UIKit

class LibraryViewController: UIViewController {
    
    private var newScanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNavBar()
    }
    
    func setupLayout() {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
    }
    
    func setupNavBar() {
        self.title = "Library"
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        
        newScanButton = UIButton()
        newScanButton.translatesAutoresizingMaskIntoConstraints = false

        let scanImageConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        let scanButtonImage = UIImage(systemName: "camera.circle.fill", withConfiguration: scanImageConfig)
        newScanButton.setImage(scanButtonImage, for: .normal)
        newScanButton.addTarget(self, action: #selector(newScanTapped(_:)), for: .touchUpInside)
        
        navigationBar.addSubview(newScanButton)
        NSLayoutConstraint.activate([
            newScanButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12),
            newScanButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant:  -16),
            newScanButton.heightAnchor.constraint(equalToConstant: 40),
            newScanButton.widthAnchor.constraint(equalTo: newScanButton.heightAnchor)
            
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
    }
    
    @objc func newScanTapped(_ sender: UIButton!) {
        let scaner = UINavigationController(rootViewController: QRScanerViewController())
        scaner.modalPresentationStyle = .fullScreen
        self.present(scaner, animated: true, completion: nil)
    }
    

}

