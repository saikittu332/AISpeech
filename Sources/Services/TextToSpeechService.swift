import Foundation
import AVFoundation

/// Service for text-to-speech conversion
class TextToSpeechService: NSObject, ObservableObject {
    static let shared = TextToSpeechService()
    
    // MARK: - Published Properties
    
    @Published var isSpeaking = false
    @Published var speechRate: Float = AVSpeechUtteranceDefaultSpeechRate
    @Published var volume: Float = 1.0
    
    // MARK: - Private Properties
    
    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    // MARK: - Speech Control
    
    func speak(_ text: String, language: String = "en-US") {
        // Stop any ongoing speech
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Create utterance
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = speechRate
        utterance.volume = volume
        
        currentUtterance = utterance
        
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Logger.shared.error("Failed to configure audio session: \(error)")
        }
        
        // Speak
        synthesizer.speak(utterance)
        
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
        
        Logger.shared.info("Started speaking: \(text.prefix(50))...")
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: .word)
        Logger.shared.info("Speech paused")
    }
    
    func resume() {
        synthesizer.continueSpeaking()
        Logger.shared.info("Speech resumed")
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
        Logger.shared.info("Speech stopped")
    }
    
    // MARK: - Available Voices
    
    func availableVoices(for language: String? = nil) -> [AVSpeechSynthesisVoice] {
        if let language = language {
            return AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix(language) }
        }
        return AVSpeechSynthesisVoice.speechVoices()
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension TextToSpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Logger.shared.debug("Speech started")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
        Logger.shared.debug("Speech finished")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        Logger.shared.debug("Speech paused")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        Logger.shared.debug("Speech continued")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
        Logger.shared.debug("Speech cancelled")
    }
}
