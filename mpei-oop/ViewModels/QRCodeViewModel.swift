import DTBunchOfExt

class QRCodeViewModel {
    private var _code: Box<QRCode?> = Box(nil)
    public var code: QRCode? { return _code.value }
    
    init(stringValue: String) {
        set(stringValue: stringValue)
    }
    
    init() {
        _code.value = nil
    }
    
    func set(stringValue: String) {
        let tempcode = QRCode(stringValue: stringValue)
        if tempcode.stringValue.hasPrefix("WIFI:") {
            let wifiqr = WiFiQRCode(stringValue: tempcode.stringValue)
            if wifiqr.ssid != nil {
                _code.value = wifiqr
            }
        } else {
            _code.value = tempcode
        }
    }
    
    func updateTitle(_ title: String?) {
        if let tempCode = code {
            tempCode.title = title
            _code.value = tempCode
        }
    }
    
    func updateDescription(_ description: String?) {
        if let tempCode = code {
            tempCode.description = description
            _code.value = tempCode
        }
    }
    
    func erase() {
        _code.value = nil
    }
    
    func bind(_ listener: @escaping ((QRCode?) -> Void)) {
        _code.bind(listener: listener)
    }
}
