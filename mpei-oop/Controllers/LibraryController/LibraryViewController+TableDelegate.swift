import UIKit

extension LibraryViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if qrData != nil {
            return qrData!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qrCodeCell", for: indexPath) as! QRCodeTableViewCell
                
        if qrData != nil && qrData.count > 0{
            cell.qr =  qrData![indexPath.row].qr
        }
        
        cell.layoutIfNeeded()
        
//        print(cell.bounds.height ,cell.imageView?.bounds.height)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = QRDetailedViewController()
        vc.qrData = self.qrData[indexPath.row]
        vc.onDismissAction = { [self] in
            CoreDataManager().deleteAsync(id: qrData[indexPath.row].id) {
                CoreDataManager().loadAsync { result in
                    self.qrData = result
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
