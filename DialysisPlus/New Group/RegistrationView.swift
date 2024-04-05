//
//  RegistrationView.swift
//  DialysisPlus
//
//  Created by Abilasha  on 02/04/24.
//
import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var confirmPassword = ""
    
    @EnvironmentObject var viewModel: AuthViewModel // Make sure AuthViewModel is properly set up
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            // Image
            Image("applogo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            // Form fields
            VStack(spacing: 24) {
                InputView(text: $fullname,
                          title: "Name",
                          placeholder: "Enter Your Name")
                
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                
                      if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large) // Fixed typo here
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large) // Fixed typo here
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Sign up button
            Button(action: {
                Task {
                    do {
                        try await viewModel.createUser(withEmail: email, password: password, fullName: fullname)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }) {
                HStack {
                    Text("SIGN UP")
                    .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
               .disabled(!formIsValid)
               .opacity(formIsValid ? 1.0 : 0.5)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
           
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            // Sign in button
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
            && confirmPassword == password
            && !fullname.isEmpty // Changed condition to check if fullname is not empty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
