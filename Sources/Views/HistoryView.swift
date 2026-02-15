import SwiftUI

/// History view showing past transcriptions
struct HistoryView: View {
    @StateObject private var viewModel = SpeechViewModel()
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var selectedTranscript: SpeechRecognitionResult?
    
    var filteredTranscripts: [SpeechRecognitionResult] {
        if searchText.isEmpty {
            return viewModel.transcriptHistory
        }
        return viewModel.transcriptHistory.filter {
            $0.transcript.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.transcriptHistory.isEmpty {
                    EmptyHistoryView()
                } else {
                    List {
                        ForEach(filteredTranscripts) { transcript in
                            NavigationLink(destination: TranscriptDetailView(transcript: transcript, viewModel: viewModel)) {
                                TranscriptRow(transcript: transcript)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    selectedTranscript = transcript
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search transcripts")
                    .refreshable {
                        // Reload data
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.transcriptHistory.isEmpty {
                        Menu {
                            Button(role: .destructive) {
                                showingDeleteAlert = true
                            } label: {
                                Label("Clear All", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .alert("Delete Transcript", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let transcript = selectedTranscript {
                        viewModel.deleteTranscript(transcript)
                    } else {
                        viewModel.clearHistory()
                    }
                }
            } message: {
                Text(selectedTranscript != nil ? "Are you sure you want to delete this transcript?" : "Are you sure you want to delete all transcripts?")
            }
        }
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: Constants.UI.spacing * 2) {
            Image(systemName: "clock")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            Text("No History Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your transcription history will appear here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct TranscriptRow: View {
    let transcript: SpeechRecognitionResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(transcript.transcript)
                .font(.body)
                .lineLimit(2)
            
            HStack {
                Label(transcript.timestamp.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                ConfidenceBadge(confidence: transcript.confidence)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ConfidenceBadge: View {
    let confidence: Float
    
    var color: Color {
        if confidence >= 0.8 {
            return .green
        } else if confidence >= 0.6 {
            return .orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        Text("\(Int(confidence * 100))%")
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(8)
    }
}

struct TranscriptDetailView: View {
    let transcript: SpeechRecognitionResult
    @ObservedObject var viewModel: SpeechViewModel
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.spacing * 2) {
                // Metadata
                VStack(alignment: .leading, spacing: Constants.UI.spacing) {
                    InfoRow(label: "Date", value: transcript.timestamp.formatted(date: .complete, time: .standard))
                    InfoRow(label: "Duration", value: String(format: "%.1f seconds", transcript.duration))
                    InfoRow(label: "Language", value: transcript.language)
                    
                    HStack {
                        Text("Confidence:")
                            .foregroundColor(.secondary)
                        ConfidenceBadge(confidence: transcript.confidence)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(Constants.UI.cornerRadius)
                .shadow(radius: 2)
                
                // Transcript
                VStack(alignment: .leading, spacing: Constants.UI.spacing) {
                    Text("Transcript")
                        .font(.headline)
                    
                    Text(transcript.transcript)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(Constants.UI.cornerRadius / 2)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(Constants.UI.cornerRadius)
                .shadow(radius: 2)
                
                // Actions
                VStack(spacing: Constants.UI.spacing) {
                    Button(action: {
                        viewModel.speak(transcript.transcript)
                    }) {
                        Label("Speak", systemImage: "speaker.wave.2")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.UI.cornerRadius)
                    }
                    
                    Button(action: {
                        viewModel.processWithAI(transcript.transcript)
                    }) {
                        Label("Process with AI", systemImage: "brain.head.profile")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.UI.cornerRadius)
                    }
                    
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.UI.cornerRadius)
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [transcript.transcript])
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .foregroundColor(.secondary)
            Text(value)
            Spacer()
        }
        .font(.subheadline)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
