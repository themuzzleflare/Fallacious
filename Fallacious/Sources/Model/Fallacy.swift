import Foundation
import CloudKit

struct Fallacy: Hashable, Identifiable {
    var id = UUID()
    
    var recordID: CKRecord.ID?
    
    var customId: Int64 = 0
    
    var number: Int64 = 0
    
    var name: String = ""
    
    var categoryName: String = ""
    
    var categoryNamePlural: String = ""
    
    var shortDescription: String = ""
    
    var longDescription: String = ""
    
    var example: String = ""
    
    var symbol: String = ""
    
    var isFeatured: Int64 = 0
    
    var featured: Bool {
        return Bool(truncating: NSNumber(value: isFeatured))
    }
    
    var lastUpdated: Date?
    
    var updateDate: String {
        if let date = lastUpdated {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            
            return dateFormatter.string(from: date)
        } else {
            return "Unknown"
        }
    }
}
