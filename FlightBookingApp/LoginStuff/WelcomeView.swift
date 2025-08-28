//
//  ContentView.swift
//  LoginPage
//
//  Created by Prathmesh Parteki on 24/08/24.
//

import SwiftUI

enum ViewStack{
    case login
    case registration
}

struct WelcomeView: View {
    
    @State private var presentNextView = false
    @State private var nextView : ViewStack = .login
    
    var body: some View {
        NavigationStack{
            VStack{
                Image("WelcomeImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 370)
                    .padding(.top,24)

                Text("Wings to Your Dream Destination.")
                    .font(.system(size: 35,weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("primaryBlue"))
                    .padding(.bottom,8)
                
                
                Text("Discover great deals and explore new places — wherever you want to go.")
                    .font(.system(size: 15,weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)

                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $presentNextView) {
                switch nextView {
                case .login:
                    LoginView()
                case .registration:
                    RegistrationView()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
