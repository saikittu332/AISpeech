import SwiftUI

/// Login view for user authentication
struct LoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var showingRegistration = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.UI.spacing * 2) {
                    // Logo and title
                    VStack(spacing: Constants.UI.spacing) {
                        Image(systemName: "waveform.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("AISpeech")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 60)
                    
                    // Login form
                    VStack(spacing: Constants.UI.spacing) {
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onSubmit {
                                if viewModel.canLogin {
                                    viewModel.login()
                                }
                            }
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button(action: {
                            viewModel.login()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: Constants.UI.buttonHeight)
                            } else {
                                Text("Sign In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: Constants.UI.buttonHeight)
                            }
                        }
                        .background(viewModel.canLogin ? Color.blue : Color.gray)
                        .cornerRadius(Constants.UI.cornerRadius)
                        .disabled(!viewModel.canLogin || viewModel.isLoading)
                        
                        Button("Forgot Password?") {
                            // TODO: Implement forgot password
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal, Constants.UI.padding)
                    
                    // Registration link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.secondary)
                        Button("Sign Up") {
                            showingRegistration = true
                        }
                        .foregroundColor(.blue)
                    }
                    .font(.subheadline)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingRegistration) {
                RegistrationView(viewModel: viewModel)
            }
        }
    }
}

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(Constants.UI.cornerRadius)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthenticationViewModel())
    }
}
