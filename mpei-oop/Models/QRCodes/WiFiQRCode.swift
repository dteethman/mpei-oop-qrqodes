import UIKit

class WiFiQRCode: QRCode {
    enum ProtectionType: String {
        case nopass = "nopass"
        case wpa = "WPA/WPA2"
        case wep = "WEP"
    }
    
    private(set) var ssid: String?
    private(set) var password: String?
    private(set) var protection: ProtectionType?
    private(set) var isHidden: Bool?
    
    
    override init(stringValue: String) {
        super.init(stringValue: stringValue)
        setDetailsFromString(stringValue: stringValue)
        
    }
    
    override init(stringValue: String, title: String, description: String?) {
        super.init(stringValue: stringValue, title: title, description: description)
        setDetailsFromString(stringValue: stringValue)
    }
    
    override func getInfo() -> NSAttributedString {
        let resStr = NSMutableAttributedString()
        let blackAtr = [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                        NSMutableAttributedString.Key.foregroundColor: UIColor.label]
        let plainAtr = [NSMutableAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                        NSMutableAttributedString.Key.foregroundColor: UIColor.label]
        
        var blackStr = NSMutableAttributedString(string: "", attributes: blackAtr)
        var plainStr = NSMutableAttributedString(string: "", attributes: plainAtr)
        
        if ssid != nil {
            blackStr = NSMutableAttributedString(string: "SSID: ", attributes: blackAtr)
            plainStr = NSMutableAttributedString(string: ssid! + "\n", attributes: plainAtr)
            
            resStr.append(blackStr)
            resStr.append(plainStr)
            
        } else {
            blackStr = NSMutableAttributedString(string: "Something went wrong", attributes: blackAtr)
            resStr.append(blackStr)
            return resStr
        }
        
        switch protection {
        case .nopass:
            blackStr = NSMutableAttributedString(string: "Protection: ", attributes: blackAtr)
            plainStr = NSMutableAttributedString(string: "none\n", attributes: plainAtr)
            
            resStr.append(blackStr)
            resStr.append(plainStr)
        case .wep, .wpa:
            blackStr = NSMutableAttributedString(string: "Protection: ", attributes: blackAtr)
            plainStr = NSMutableAttributedString(string: protection!.rawValue + "\n", attributes: plainAtr)
            
            resStr.append(blackStr)
            resStr.append(plainStr)
            
            if password != nil {
                blackStr = NSMutableAttributedString(string: "Password: ", attributes: blackAtr)
                plainStr = NSMutableAttributedString(string: password! + "\n", attributes: plainAtr)
                
                resStr.append(blackStr)
                resStr.append(plainStr)
            }
        case nil:
            break
        }
        
        if isHidden != nil {
            if isHidden! {
                plainStr = NSMutableAttributedString(string: "Hidden network", attributes: plainAtr)

                resStr.append(plainStr)
            }
        }
        
        
        return resStr
    }
    
    private func setDetailsFromString(stringValue: String) {
        if stringValue.hasPrefix("WIFI:") {
            let data = stringValue.dropFirst(5)
            var params = data.components(separatedBy: ";")
            while params.contains("") {
                params.remove(at: params.lastIndex(of: "")!)
            }

            var paramsDict: [String: String?] = [:]
            for param in params {
                let paramComponents = param.components(separatedBy: ":")
                let key = paramComponents[0]
                let value = paramComponents[1]
                paramsDict[key] = value
                
            }
            
            ssid = paramsDict["S"] ?? nil
            password = paramsDict["P"] ?? nil
            if paramsDict["H"] != nil {
                if paramsDict["H"]! == "true" {
                    isHidden = true
                } else {
                    isHidden = false
                }
            } else {
                isHidden = nil
            }
            
            if paramsDict["T"] != nil {
                if paramsDict["T"]! == "WPA" {
                    protection = .wpa
                } else if paramsDict["T"]! == "WEP" {
                    protection = .wep
                } else if paramsDict["T"]! == "nopass" || paramsDict["T"]! == "" {
                    protection = .nopass
                }
            } else {
                protection = nil
            }
            
            
        }
    }
}
