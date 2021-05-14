import CoreData
import DTBunchOfExt

class LibraryViewModel {
    var library: Box<[(QRCode, NSManagedObjectID)]?> = Box(nil)
    
    private var dataManager: QRDataManager
    
    init(dataManager: QRDataManager) {
        self.dataManager = dataManager
    }
    
    func loadLibrary() {
        dataManager.loadAsync { [ weak self ] result in
            self?.library.value = result
        }
    }
    
    func delete(id: NSManagedObjectID) {
        dataManager.deleteAsync(id: id) { [weak self] in
            self?.loadLibrary()
        }
    }
}
