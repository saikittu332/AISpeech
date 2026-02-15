import CoreData
import Foundation

/// Core Data persistence controller
class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // MARK: - Initialization
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "AISpeech")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Preview Support
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Add sample data for previews
        for i in 0..<5 {
            let entity = TranscriptEntity(context: viewContext)
            entity.id = UUID()
            entity.text = "Sample transcript \(i)"
            entity.timestamp = Date().addingTimeInterval(TimeInterval(-i * 3600))
            entity.confidence = Float.random(in: 0.8...1.0)
        }
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Failed to save preview data: \(error)")
        }
        
        return controller
    }()
    
    // MARK: - Save Context
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                Logger.shared.error("Failed to save context: \(error)")
            }
        }
    }
}
