import Foundation
import Speech
import AVFoundation

/// Service for speech recognition using Apple's Speech framework
class SpeechRecognitionService: NSObject, ObservableObject {
    static let shared = SpeechRecognitionService()
    
    // MARK: - Published Properties
    
    @Published var isRecording = false
    @Published var transcription = ""
    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    
    // MARK: - Private Properties
    
    private let speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var onResult: ((SpeechRecognitionResult) -> Void)?
    private var startTime: Date?
    
    // MARK: - Initialization
    
    override init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        super.init()
        
        Task {
            await requestAuthorization()
        }
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() async {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                DispatchQueue.main.async {
                    self.authorizationStatus = status
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - Recording Control
    
    func startRecording(onResult: @escaping (SpeechRecognitionResult) -> Void) throws {
        // Cancel any ongoing task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechError.recognitionRequestCreationFailed
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Get audio input node
        let inputNode = audioEngine.inputNode
        
        // Store callback
        self.onResult = onResult
        self.startTime = Date()
        
        // Create recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let transcript = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self.transcription = transcript
                }
                
                if result.isFinal {
                    let speechResult = SpeechRecognitionResult(
                        transcript: transcript,
                        confidence: self.calculateConfidence(result),
                        timestamp: self.startTime ?? Date(),
                        duration: Date().timeIntervalSince(self.startTime ?? Date())
                    )
                    self.onResult?(speechResult)
                }
            }
            
            if error != nil || result?.isFinal == true {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }
        
        // Configure audio input
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        // Start audio engine
        audioEngine.prepare()
        try audioEngine.start()
        
        DispatchQueue.main.async {
            self.isRecording = true
            self.transcription = ""
        }
        
        Logger.shared.info("Speech recognition started")
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            
            DispatchQueue.main.async {
                self.isRecording = false
            }
            
            Logger.shared.info("Speech recognition stopped")
        }
    }
    
    // MARK: - Helper Methods
    
    private func calculateConfidence(_ result: SFSpeechRecognitionResult) -> Float {
        let segments = result.bestTranscription.segments
        guard !segments.isEmpty else { return 0.0 }
        
        let totalConfidence = segments.reduce(0.0) { $0 + $1.confidence }
        return totalConfidence / Float(segments.count)
    }
}

// MARK: - Speech Errors

enum SpeechError: LocalizedError {
    case recognitionRequestCreationFailed
    case audioEngineNotAvailable
    case recognizerNotAvailable
    case notAuthorized
    
    var errorDescription: String? {
        switch self {
        case .recognitionRequestCreationFailed:
            return "Unable to create speech recognition request"
        case .audioEngineNotAvailable:
            return "Audio engine is not available"
        case .recognizerNotAvailable:
            return "Speech recognizer is not available"
        case .notAuthorized:
            return "Speech recognition not authorized"
        }
    }
}
