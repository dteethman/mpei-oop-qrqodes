import UIKit

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if qrData != nil {
            return qrData!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qrCodeCell", for: indexPath) as! QRCodeTableViewCell
                
        if qrData != nil && qrData.count > 0{
            cell.qr =  qrData![indexPath.row].qr
        }
        
        cell.layoutIfNeeded()
        
//        print(cell.bounds.height ,cell.imageView?.bounds.height)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    
}
