//
//  LoginView.swift
//  LoginPage
//
//  Created by Prathmesh Parteki on 24/08/24.
//

import SwiftUI

enum FocusedField {
    case email
    case password
}

struct LoginView: View {
    @State private var emailText = ""
    @State private var passwordText = ""
    
    @FocusState private var focusedField: FocusedField?
    @State private var isValidEmail = true
    @State private var isValidPassword = true
    
    @State private var showContentView = false
    @State private var showRegistrationView = false
    
    var canProceed : Bool {
        Validator.validateEmail(emailText) && Validator.validatePassword(passwordText)
    }
    
    var body: some View {
        NavigationStack{
            if showContentView {
                ContentView()
            } else if showRegistrationView {
                RegistrationView()
            } else {
                VStack{
                    Text("Login Here")
                        .font(.system(size: 30,weight: .bold))
                        .foregroundColor(Color("primaryBlue"))
                        .padding(.bottom)
                    
                    Text("Welcome back you've \n been missed!")
                        .font(.system(size: 16,weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom,70)
                    
                    EmailTextFieldView(emailText: $emailText, isValidEmail: $isValidEmail)
                        .padding(.bottom,15)
                    
                    PasswordTextFieldView(passwordText: $passwordText, isValidPassword: $isValidPassword, flag: "" ,errorText: "Your password should be comprised of at least 8 characters.It should contain uppercase letter, lowercase letter, number, and even some special characters...", placeHolderText: "Password")
                    
                    HStack{
                        Spacer()
                        Button{
                            
                        }label: {
                            Text("Forgot password?")
                                .foregroundColor(Color("primaryBlue"))
                                .font(.system(size: 14,weight: .semibold))
                        }
                        .padding(.trailing)
                        .padding(.vertical)
                    }
                    
                    Button {
                        showContentView = true
                    } label: {
                        Text("Sign in")
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
                        showRegistrationView = true
                    } label: {
                        Text("Create new account")
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
        .animation(.easeInOut(duration: 0.35), value: showContentView)
        .animation(.easeInOut(duration: 0.35), value: showRegistrationView)
    }
}

struct BottomView : View {
    var body: some View {
        VStack{
            Text("Or continue with")
                .font(.system(size: 14,weight: .semibold))
                .foregroundColor(Color("primaryBlue"))
            
            HStack {
                Button{
                    
                }label: {
                    Image("google-logo")
                }
                .iconButtonStyle
                Button{
                    
                }label: {
                    Image("facebook-logo")
                }
                .iconButtonStyle
                Button{
                    
                }label: {
                    Image("apple-logo")
                }
                .iconButtonStyle
            }
            
            
        }
    }
}
extension View {
    var iconButtonStyle : some View {
        self 
            .padding()
            .background(Color("lightGray"))
            .cornerRadius(8)
    }
}
struct EmailTextFieldView : View {
    @Binding var emailText : String
    @Binding var isValidEmail : Bool
    
    @FocusState var focusedField : FocusedField?
    
    var body: some View{
        VStack{
            TextField("Email",text: $emailText)
                .focused($focusedField,equals: .email)
                .padding()
                .background(Color("secondaryBlue"))
                .cornerRadius(12)
                .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(!isValidEmail && !emailText.isEmpty ? .red : focusedField == .email ? Color("primaryBlue") : .white,lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: emailText) { newValue in
                    isValidEmail = Validator.validateEmail(newValue)
                }
            if !isValidEmail && !emailText.isEmpty {
                HStack {
                    Text("Enter a valid email")
                        .foregroundColor(.red)
                        .padding(.leading)
                    Spacer()
                }
                .padding(.bottom, isValidEmail ? 16 : 0)
            }
        }
    }
}
struct PasswordTextFieldView : View {
    @Binding var passwordText : String
    @Binding var isValidPassword : Bool
    var flag : String
    let errorText : String
    let placeHolderText : String
    
    @FocusState var focusedField : FocusedField?
    var body: some View{
        VStack {
            TextField(placeHolderText,text: $passwordText)
                .focused($focusedField,equals: .password)
                .padding()
                .background(Color("secondaryBlue"))
                .cornerRadius(12)
                .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(!isValidPassword && !passwordText.isEmpty ? .red : focusedField == .password ? Color("primaryBlue") : .white,lineWidth: 3)
                )
                .padding(.horizontal)
                .onChange(of: passwordText) { newValue in
                    if flag.isEmpty {
                        isValidPassword = Validator.validatePassword(newValue)
                    } else {
                        isValidPassword = flag == newValue ? true : false
                    }
                }
            if !isValidPassword && !passwordText.isEmpty {
                HStack {
                    Text(errorText)
                        .foregroundColor(.gray)
                        .padding(.leading)
                    Spacer()
                }
                .padding(.bottom, isValidPassword ? 16 : 0)
            }
        }
    }
}
#Preview {
    LoginView()
}
