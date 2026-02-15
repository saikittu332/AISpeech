import CoreData

/// Core Data entity for storing transcript history
@objc(TranscriptEntity)
public class TranscriptEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var confidence: Float
    @NSManaged public var timestamp: Date?
    @NSManaged public var duration: Double
    @NSManaged public var language: String?
    @NSManaged public var audioFileURL: String?
}

extension TranscriptEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TranscriptEntity> {
        return NSFetchRequest<TranscriptEntity>(entityName: "TranscriptEntity")
    }
    
    /// Converts to SpeechRecognitionResult model
    func toModel() -> SpeechRecognitionResult? {
        guard let id = id,
              let text = text,
              let timestamp = timestamp else {
            return nil
        }
        
        return SpeechRecognitionResult(
            id: id,
            transcript: text,
            confidence: confidence,
            timestamp: timestamp,
            duration: duration,
            language: language ?? "en-US"
        )
    }
    
    /// Creates entity from model
    static func fromModel(_ model: SpeechRecognitionResult, context: NSManagedObjectContext) -> TranscriptEntity {
        let entity = TranscriptEntity(context: context)
        entity.id = model.id
        entity.text = model.transcript
        entity.confidence = model.confidence
        entity.timestamp = model.timestamp
        entity.duration = model.duration
        entity.language = model.language
        return entity
    }
}
