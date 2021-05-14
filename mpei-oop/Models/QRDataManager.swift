import CoreData
import UIKit

class QRDataManager {
    private let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    lazy var context = persistentContainer?.viewContext
    
    func loadAsync(completion: (@escaping (_ result: [(qr: QRCode, id: NSManagedObjectID)]) -> Void)) {
        let workerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        //set the parent NOT the persistent store coordinator
        if let context = self.context {
            workerContext.parent = context

            workerContext.perform({

                let fetchRequest = NSFetchRequest<QRCodes>(entityName: "QRCodes")
                
                let sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
                fetchRequest.sortDescriptors = sortDescriptors
                
                var result: [(QRCode, NSManagedObjectID)] = []
                
                do {
                    let fetchedObjects = try context.fetch(fetchRequest)
                    
                    for obj in fetchedObjects {
                        if let stringValue = obj.stringValue, let title = obj.title {
                            if obj.type == "wifi" {
                                let qr = WiFiQRCode(stringValue: stringValue, title: title, description: obj.desc)
                                result.append((qr, obj.objectID))
                            } else {
                                let qr = QRCode(stringValue: stringValue, title: title, description: obj.desc)
                                result.append((qr, obj.objectID))
                            }
                        }
                    }
                    if result.count > 0 {
                        DispatchQueue.main.async {
                            completion(result)
                        }
                        
                    }
                    
                } catch  {
                    print("Error fetchuing QRs")
                }

            })
        }
        
    }
    
    func load() -> [(qr: QRCode, id: NSManagedObjectID)]? {
        if let context = self.context {
            let fetchRequest = NSFetchRequest<QRCodes>(entityName: "QRCodes")
            
            let sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: true)]
            fetchRequest.sortDescriptors = sortDescriptors
            
            var result: [(QRCode, NSManagedObjectID)] = []
            
            do {
                let fetchedObjects = try context.fetch(fetchRequest)
                
                for obj in fetchedObjects {
                    if let stringValue = obj.stringValue, let title = obj.title {
                        if obj.type == "wifi" {
                            let qr = WiFiQRCode(stringValue: stringValue, title: title, description: obj.desc)
                            result.append((qr, obj.objectID))
                        } else {
                            let qr = QRCode(stringValue: stringValue, title: title, description: obj.desc)
                            result.append((qr, obj.objectID))
                        }
                    }
                    
                }
                return result
                
            } catch  {
                print("Error fetchuing QRs")
                return nil
            }
            
        }
        
        return nil
    }
    
    func save(qr: QRCode) {
        if let context = self.context {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "QRCodes", in: context) else {
                return
            }
            
            let newObj = NSManagedObject(entity: entityDescription, insertInto: context)
            
            guard let title = qr.title else { return }
            newObj.setValue(qr.stringValue, forKey: "stringValue")
            newObj.setValue(title, forKey: "title")
            newObj.setValue(qr.description, forKey: "desc")
            if qr is WiFiQRCode {
                newObj.setValue("wifi", forKey: "type")
            }
            newObj.setValue(Date(), forKey: "dateAdded")
            
            do {
                try context.save()
            } catch {
                print("Error saving QR \(qr.stringValue)")
                return
            }
        }
    }
    
    func deleteAsync(id: NSManagedObjectID, completion: (@escaping () -> Void)) {
        let workerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        //set the parent NOT the persistent store coordinator
        if let context = self.context {
            workerContext.parent = context

            workerContext.perform({
                do {
                    let obj = context.object(with: id)
                    context.delete(obj)
                    try context.save()
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    return
                }

            })
        }
    }
    
    func delete(id: NSManagedObjectID) {
        if let context = self.context {
            do {
                let obj = context.object(with: id)
                context.delete(obj)
                try context.save()
            } catch {
                return
            }
        }
    }
    
}
