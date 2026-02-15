import SwiftUI

/// Main speech recognition view
struct SpeechRecognitionView: View {
    @StateObject private var viewModel = SpeechViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showingTranscriptDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Constants.UI.spacing * 2) {
                        // Status card
                        StatusCard(isRecording: viewModel.isRecording)
                            .padding(.top, Constants.UI.padding)
                        
                        // Record button
                        RecordButton(
                            isRecording: viewModel.isRecording,
                            action: {
                                if viewModel.isRecording {
                                    viewModel.stopRecording()
                                } else {
                                    viewModel.startRecording()
                                }
                            }
                        )
                        .padding(.vertical, Constants.UI.padding)
                        
                        // Current transcript
                        if !viewModel.currentTranscript.isEmpty {
                            TranscriptCard(
                                title: "Current Transcription",
                                transcript: viewModel.currentTranscript,
                                showProcessButton: !viewModel.isProcessing,
                                onProcess: {
                                    viewModel.processWithAI(viewModel.currentTranscript)
                                },
                                onSpeak: {
                                    viewModel.speak(viewModel.currentTranscript)
                                }
                            )
                        }
                        
                        // AI Result
                        if let aiResult = viewModel.aiResult {
                            AIResultCard(result: aiResult)
                        }
                        
                        // Loading indicator
                        if viewModel.isProcessing {
                            HStack {
                                ProgressView()
                                Text("Processing with AI...")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                        
                        // Error message
                        if let error = viewModel.errorMessage {
                            ErrorCard(message: error)
                        }
                    }
                    .padding(.horizontal, Constants.UI.padding)
                }
            }
            .navigationTitle("AISpeech")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Supporting Views

struct StatusCard: View {
    let isRecording: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isRecording ? "waveform" : "mic.slash")
                .font(.title2)
                .foregroundColor(isRecording ? .green : .secondary)
            
            Text(isRecording ? "Recording..." : "Ready to record")
                .font(.headline)
            
            Spacer()
            
            if isRecording {
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: isRecording)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(radius: 4)
    }
}

struct RecordButton: View {
    let isRecording: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isRecording ? Color.red : Color.blue)
                    .frame(width: 120, height: 120)
                    .shadow(radius: isRecording ? 8 : 4)
                    .scaleEffect(isRecording ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isRecording)
                
                Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
        }
        .accessibilityLabel(isRecording ? "Stop recording" : "Start recording")
    }
}

struct TranscriptCard: View {
    let title: String
    let transcript: String
    let showProcessButton: Bool
    let onProcess: () -> Void
    let onSpeak: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.spacing) {
            Text(title)
                .font(.headline)
            
            Text(transcript)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(Constants.UI.cornerRadius / 2)
            
            HStack {
                if showProcessButton {
                    Button(action: onProcess) {
                        Label("Process with AI", systemImage: "brain.head.profile")
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.UI.cornerRadius / 2)
                    }
                }
                
                Button(action: onSpeak) {
                    Label("Speak", systemImage: "speaker.wave.2")
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.UI.cornerRadius / 2)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(radius: 4)
    }
}

struct AIResultCard: View {
    let result: AIProcessingResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.spacing) {
            Text("AI Analysis")
                .font(.headline)
            
            if let sentiment = result.sentiment {
                HStack {
                    Text("Sentiment:")
                        .foregroundColor(.secondary)
                    Text(sentiment)
                        .fontWeight(.semibold)
                }
            }
            
            if !result.keywords.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Keywords:")
                        .foregroundColor(.secondary)
                    
                    FlowLayout(spacing: 8) {
                        ForEach(result.keywords, id: \.self) { keyword in
                            Text(keyword)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                }
            }
            
            if let summary = result.summary {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Summary:")
                        .foregroundColor(.secondary)
                    Text(summary)
                        .font(.body)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(Constants.UI.cornerRadius)
        .shadow(radius: 4)
    }
}

struct ErrorCard: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.red)
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(Constants.UI.cornerRadius)
    }
}

// Flow layout for keywords
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

struct SpeechRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechRecognitionView()
            .environmentObject(AppState())
    }
}
