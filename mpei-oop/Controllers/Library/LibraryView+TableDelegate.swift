import UIKit

extension LibraryView {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let qrData = self.viewModel.library else { return 0 }
        return qrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! LibraryCell
        
        guard let library = self.viewModel.library else { return cell }

        if library.count > 0 {
            cell.update(viewModel: self.viewModel, index: indexPath.row)
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let codes = self.viewModel.library else { return }
        
        let vc = QRDetailedViewController()
        vc.qrData = codes[indexPath.row]
        vc.onDismissAction = { [weak self] in
            let id = codes[indexPath.row].id
            self?.viewModel.delete(id: id)
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
