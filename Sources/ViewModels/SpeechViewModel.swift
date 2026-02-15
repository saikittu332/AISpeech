import Foundation
import Combine
import CoreData

/// ViewModel for speech recognition functionality
class SpeechViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var isRecording = false
    @Published var currentTranscript = ""
    @Published var transcriptHistory: [SpeechRecognitionResult] = []
    @Published var isProcessing = false
    @Published var errorMessage: String?
    @Published var aiResult: AIProcessingResult?
    
    // MARK: - Private Properties
    
    private let speechService = SpeechRecognitionService.shared
    private let ttsService = TextToSpeechService.shared
    private let aiService = AIProcessingService.shared
    private let persistenceController = PersistenceController.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupBindings()
        loadTranscriptHistory()
    }
    
    private func setupBindings() {
        speechService.$transcription
            .assign(to: &$currentTranscript)
        
        speechService.$isRecording
            .assign(to: &$isRecording)
    }
    
    // MARK: - Speech Recognition
    
    func startRecording() {
        guard !isRecording else { return }
        
        do {
            try speechService.startRecording { [weak self] result in
                self?.handleRecognitionResult(result)
            }
            Logger.shared.info("Recording started")
        } catch {
            errorMessage = error.localizedDescription
            Logger.shared.error("Failed to start recording: \(error)")
        }
    }
    
    func stopRecording() {
        guard isRecording else { return }
        
        speechService.stopRecording()
        Logger.shared.info("Recording stopped")
    }
    
    private func handleRecognitionResult(_ result: SpeechRecognitionResult) {
        transcriptHistory.insert(result, at: 0)
        saveTranscript(result)
        
        // Process with AI if confidence is high enough
        if result.confidence >= Constants.Speech.minConfidence {
            processWithAI(result.transcript)
        }
    }
    
    // MARK: - AI Processing
    
    func processWithAI(_ text: String) {
        isProcessing = true
        
        Task {
            do {
                let result = try await aiService.processTranscript(text)
                
                await MainActor.run {
                    self.aiResult = result
                    self.isProcessing = false
                    Logger.shared.info("AI processing completed")
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isProcessing = false
                    Logger.shared.error("AI processing failed: \(error)")
                }
            }
        }
    }
    
    // MARK: - Text-to-Speech
    
    func speak(_ text: String) {
        ttsService.speak(text)
    }
    
    func stopSpeaking() {
        ttsService.stop()
    }
    
    // MARK: - Persistence
    
    private func saveTranscript(_ result: SpeechRecognitionResult) {
        let context = persistenceController.container.viewContext
        _ = TranscriptEntity.fromModel(result, context: context)
        persistenceController.save()
        Logger.shared.debug("Transcript saved to Core Data")
    }
    
    private func loadTranscriptHistory() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<TranscriptEntity> = TranscriptEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = Constants.Storage.maxTranscriptHistory
        
        do {
            let entities = try context.fetch(fetchRequest)
            transcriptHistory = entities.compactMap { $0.toModel() }
            Logger.shared.info("Loaded \(transcriptHistory.count) transcripts from history")
        } catch {
            Logger.shared.error("Failed to load transcript history: \(error)")
        }
    }
    
    func deleteTranscript(_ result: SpeechRecognitionResult) {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<TranscriptEntity> = TranscriptEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", result.id as CVarArg)
        
        do {
            let entities = try context.fetch(fetchRequest)
            entities.forEach { context.delete($0) }
            persistenceController.save()
            
            transcriptHistory.removeAll { $0.id == result.id }
            Logger.shared.info("Transcript deleted")
        } catch {
            Logger.shared.error("Failed to delete transcript: \(error)")
        }
    }
    
    func clearHistory() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TranscriptEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            transcriptHistory.removeAll()
            Logger.shared.info("Transcript history cleared")
        } catch {
            Logger.shared.error("Failed to clear history: \(error)")
        }
    }
}
