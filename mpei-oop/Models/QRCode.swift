import UIKit

class QRCode {
    var stringValue: String
    var title: String?
    var description: String?
    
    init(stringValue: String) {
        self.stringValue = stringValue
        self.title  = nil
        self.description = nil
    }
    
    init(stringValue: String, title: String, description: String?) {
        self.stringValue = stringValue
        self.title  = title
        self.description = description
    }
    
    func getImage() -> UIImage? {
        let data = self.stringValue.data(using: String.Encoding.utf8)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func getInfo() -> NSAttributedString {
        let resStr = NSMutableAttributedString()
        let blackAtr = [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                        NSMutableAttributedString.Key.foregroundColor: UIColor.label]
        let plainAtr = [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                        NSMutableAttributedString.Key.foregroundColor: UIColor.label]
        let blackStr = NSMutableAttributedString(string:  "Text: ", attributes: blackAtr)
        let plainStr = NSMutableAttributedString(string: stringValue, attributes: plainAtr)
        
        resStr.append(blackStr)
        resStr.append(plainStr)
        return resStr
    }
}


