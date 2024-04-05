//
//  LoginView.swift
//  DialysisPlus
//
//  Created by Abilasha  on 02/04/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                //image
                Image("applogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 120)
                    .padding(.vertical,32)
                
                //form field
                
                
                VStack(spacing: 24) {
                    
                    
                    InputView(text: $email,
                              
                              title: "Email Address",
                              
                              placeholder: "name@example.com")
                    
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              
                              title: "Password",
                              
                              placeholder: "Enter your password"
                              ,
                              
                              isSecureField: true)
                }
                .padding(.horizontal)

                .padding(.top, 12)

                // sign in button

              Button {
                  Task{
                      
                    try await  viewModel.signIn(withEmail:email, password: password)
                      
                  }

                } label: {
                    
                    HStack {
                        
                        Text("SIGN IN")
                        
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
              
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                

                    .cornerRadius (10)
                    .padding(.top,24)

                Spacer()
                
              
               NavigationLink{
                    RegistrationView()
                       .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                
            
                
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
