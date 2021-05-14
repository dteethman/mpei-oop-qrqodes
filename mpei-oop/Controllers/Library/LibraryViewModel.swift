import CoreData
import DTBunchOfExt

class LibraryViewModel {
    private var _library: Box<[(code: QRCode, id: NSManagedObjectID)]?> = Box(nil)
    public var library: [(code: QRCode, id: NSManagedObjectID)]? { return _library.value }
    
    private var dataManager: QRDataManager
    
    init(dataManager: QRDataManager) {
        self.dataManager = dataManager
    }
    
    func loadLibrary() {
        dataManager.loadAsync { [ weak self ] result in
            self?._library.value = result
        }
    }
    
    func delete(id: NSManagedObjectID) {
        dataManager.deleteAsync(id: id) { [weak self] in
            self?.loadLibrary()
        }
    }
    
    func setLibrary(_ library: [(code: QRCode, id: NSManagedObjectID)]) {
        _library.value = library
    }
    
    func bind(_ listener: @escaping ([(code: QRCode, id: NSManagedObjectID)]?) -> Void) {
        _library.bind(listener: listener)
    }
}
