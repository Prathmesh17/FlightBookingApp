//
//  RegistrationView.swift
//  LoginPage
//
//  Created by Prathmesh Parteki on 24/08/24.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var confirmPasswordText = ""
    
    @FocusState private var focusedField: FocusedField?
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    @State private var isValidConfirmPassword = true
    
    var canProceed : Bool {
        Validator.validateEmail(emailText) && Validator.validatePassword(passwordText)
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Create Account")
                    .font(.system(size: 30,weight: .bold))
                    .foregroundColor(Color("primaryBlue"))
                    .padding(.bottom)
                
                Text("Create an account so you can explore and book the Flights!")
                    .font(.system(size: 16,weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom,70)
                
                EmailTextFieldView(emailText: $emailText, isValidEmail: $isValidEmail)
                    .padding(.bottom)
                
                PasswordTextFieldView(passwordText: $passwordText, isValidPassword: $isValidPassword, flag: "",errorText: "Your password should be comprised of at least 8 characters.It should contain uppercase letter, lowercase letter, number, and even some special characters...", placeHolderText: "Password")
                    .padding(.bottom)
                
                PasswordTextFieldView(passwordText: $confirmPasswordText, isValidPassword: $isValidConfirmPassword, flag: emailText,errorText: "Your password not matches with the above one...",placeHolderText: "Confirm Password")
                    .padding(.bottom)
                
                Button {
                    
                } label: {
                    Text("Sign up")
                        .foregroundColor(.white)
                        .font(.system(size: 20,weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color("primaryBlue"))
                .cornerRadius(12)
                .padding(.horizontal)
                .opacity(canProceed ? 1.0 : 0.5)
                .disabled(!canProceed)
                
                Button {
                    LoginView()
                } label: {
                    Text("Already have an account")
                        .foregroundColor(Color("gray"))
                        .font(.system(size: 20,weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .cornerRadius(12)
                .padding()
                .disabled(!canProceed)
                
                BottomView()
            }
        }
    }
}

#Preview {
    RegistrationView()
}
