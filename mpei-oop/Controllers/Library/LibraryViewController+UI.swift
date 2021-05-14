import UIKit

extension LibraryView {
    func setupNavBar() {
        self.title = "Library"
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        
        
        newScanButton = UIButton()
        newScanButton.translatesAutoresizingMaskIntoConstraints = false

        let scanImageConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        let scanButtonImage = UIImage(systemName: "camera.circle.fill", withConfiguration: scanImageConfig)
        newScanButton.setImage(scanButtonImage, for: .normal)
        newScanButton.addTarget(self, action: #selector(scanAction(_:)), for: .touchUpInside)
        
        navigationBar.addSubview(newScanButton)
        NSLayoutConstraint.activate([
            newScanButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12),
            newScanButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant:  -16),
            newScanButton.heightAnchor.constraint(equalToConstant: 40),
            newScanButton.widthAnchor.constraint(equalTo: newScanButton.heightAnchor)
            
        ])
        
        self.observer = self.navigationController?.navigationBar.observe(\.bounds, options: [.new], changeHandler: { (navigationBar, changes) in
            if let height = changes.newValue?.height {
                self.newScanButton?.alpha = min(1, (height - 44) / 52)
            }
        })
        
        
    }
    
    func setupLayout() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(QRCodeTableViewCell.self, forCellReuseIdentifier: "qrCodeCell")
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    }
        
    func setAppearance() {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
    }

}
