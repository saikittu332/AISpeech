import SwiftUI

/// Registration view for new users
struct RegistrationView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, username, password, confirmPassword
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.UI.spacing * 2) {
                    // Title
                    VStack(spacing: Constants.UI.spacing) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Join AISpeech today")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Registration form
                    VStack(spacing: Constants.UI.spacing) {
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .username }
                        
                        if !viewModel.email.isEmpty && !viewModel.isEmailValid {
                            ValidationMessage(text: "Please enter a valid email")
                        }
                        
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .username)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }
                        
                        if !viewModel.username.isEmpty && viewModel.username.count < Constants.Validation.minUsernameLength {
                            ValidationMessage(text: "Username must be at least \(Constants.Validation.minUsernameLength) characters")
                        }
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.newPassword)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .confirmPassword }
                        
                        if !viewModel.password.isEmpty && !viewModel.isPasswordValid {
                            ValidationMessage(text: "Password must be at least \(Constants.Validation.minPasswordLength) characters")
                        }
                        
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.newPassword)
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.go)
                            .onSubmit {
                                if viewModel.canRegister {
                                    viewModel.register()
                                }
                            }
                        
                        if !viewModel.confirmPassword.isEmpty && !viewModel.doPasswordsMatch {
                            ValidationMessage(text: "Passwords do not match")
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                        }
                        
                        Button(action: {
                            viewModel.register()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: Constants.UI.buttonHeight)
                            } else {
                                Text("Create Account")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: Constants.UI.buttonHeight)
                            }
                        }
                        .background(viewModel.canRegister ? Color.blue : Color.gray)
                        .cornerRadius(Constants.UI.cornerRadius)
                        .disabled(!viewModel.canRegister || viewModel.isLoading)
                        .padding(.top, Constants.UI.spacing)
                    }
                    .padding(.horizontal, Constants.UI.padding)
                    
                    // Terms and privacy
                    Text("By creating an account, you agree to our Terms of Service and Privacy Policy")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Constants.UI.padding * 2)
                    
                    Spacer()
                }
            }
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ValidationMessage: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(text)
            Spacer()
        }
        .font(.caption)
        .foregroundColor(.orange)
        .padding(.horizontal, Constants.UI.spacing)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: AuthenticationViewModel())
    }
}
