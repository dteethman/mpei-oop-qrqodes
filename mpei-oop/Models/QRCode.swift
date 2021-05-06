import UIKit

class QRCode {
    var stringValue: String!
    var title: String?
    var description: String?
    
    init(stringValue: String) {
        self.stringValue = stringValue
        self.title  = nil
        self.description = nil
    }
    
    func getImage() -> UIImage? {
        let data = self.stringValue.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil

    }
}


