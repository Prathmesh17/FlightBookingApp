//
//  IntroView.swift
//  ComponentsApp
//
//  Created by Prathmesh Parteki on 16/06/25.
//

import SwiftUI

struct IntroView: View {
    //MARK: Animation Properties
    @State var showWalkThroughScreens : Bool = false
    @State var currentIndex : Int = 0
    @State var showRegistrationView : Bool = false
    @State var showLoginView : Bool = false
    
    var body: some View {
        ZStack{
            if showLoginView {
                LoginView()
                    .transition(.move(edge: .leading))
            }
            else if showRegistrationView {
                RegistrationView()
                    .transition(.move(edge: .trailing))
            }else{
                ZStack{
                    Color("BG")
                        .ignoresSafeArea()
                    
                    IntroScreen()
                    
                    WalkThroughScreens()
                    
                    NavBar()
                        
                }
                .animation(.spring(response: 1.1,dampingFraction: 0.85,blendDuration: 0.85), value: showWalkThroughScreens)
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showRegistrationView)
        .animation(.easeInOut(duration: 0.35), value: showLoginView)
    }
    //MARK: WalkThroughScreens
    @ViewBuilder
    func WalkThroughScreens() -> some View{
        let isLast = currentIndex == intros.count
        GeometryReader{
            let size = $0.size
            
            ZStack{
                //MARK: Walk Through Screens
                ForEach(intros.indices ,id: \.self){ index in
                    ScreenView(size: size   ,index: index)
                }
                
                WelComeView(size: size, index: intros.count)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            //MARK: Next Button
            .overlay(alignment: .bottom){
                //MARK: Converting next button into signup button
                ZStack{
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .scaleEffect(!isLast ? 1 : 0.001)
                        .opacity(!isLast ? 1 : 0)
                    
                    HStack {
                        Text("Sign Up")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        
                        Image(systemName: "arrow.right")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 15)
                    .scaleEffect(isLast ? 1 : 0.001)
                    .frame(height: isLast ? nil : 0)
                    .opacity(isLast ? 1 : 0)
                }
                .frame(width: isLast ? size.width / 1.5 : 55,height: isLast ? 50 : 55)
                .foregroundColor(.white)
                .background{
                    RoundedRectangle(cornerRadius: isLast ? 10 : 30,style: isLast ? .continuous : .circular)
                        .fill(Color("Blue"))
                }
                .onTapGesture {
                    if currentIndex == intros.count{
                        showRegistrationView = true
                    }else{
                        currentIndex += 1
                    }
                }
                .offset(y: isLast ? -40 : -90)
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5), value: isLast)
            }
            .overlay(alignment: .bottom, content: {
                //Bottom sign in Button
                let isLast = currentIndex == intros.count
                
                HStack(spacing: 5){
                    Text("Already have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Button("Login"){
                        showLoginView = true
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color("Blue"))
                }
                .offset(y: isLast ? -12 : 100)
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5), value: isLast)
            })
            .offset(y: showWalkThroughScreens ? 0 : size.height)
        }
    }
    
    @ViewBuilder
    func WelComeView(size: CGSize,index : Int) -> some View{
        VStack{
            Spacer()
            Image("WelcomeImage")
                .resizable()
                .scaledToFit()
                .frame(width: 370)
                .padding(.top,24)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            
            Spacer()
            Text("Wings to Your Dream Destination.")
                .font(.system(size: 35,weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("primaryBlue"))
                .padding(.bottom,8)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            
            
            Text("Discover great deals and explore new places — wherever you want to go.")
                .font(.system(size: 15,weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)

            
            Spacer()
        }
        .offset(y: -30)
        .padding()
    }
    @ViewBuilder
    func ScreenView(size: CGSize,index : Int) -> some View{
        let intro = intros[index]
        
        VStack(spacing: 10){
            Text(intro.title)
                .font(.system(size: 28))
                //MARK: Applying offset for Each Screen's
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Text(intro.subtitle)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal,30)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Image(intro.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250,alignment: .top)
                .padding(.horizontal,20)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9,dampingFraction: 0.8,blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
        }
    }
    
    //MARK: Nav bar
    @ViewBuilder
    func NavBar() -> some View{
        let isLast = intros.count == currentIndex
        HStack{
            Button{
                // If greater than zero then eliminating index
                if currentIndex > 0{
                    currentIndex -= 1
                }else{
                    showWalkThroughScreens.toggle()
                }
            }label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Blue"))
            }
            
            Spacer()
            
            Button("Skip"){
                currentIndex = intros.count
            }
            .font(.system(size: 18))
            .foregroundColor(Color("Blue"))
            .opacity(isLast ? 0 : 1)
            .animation(.easeInOut, value: isLast)
        }
        .padding(.horizontal,15)
        .padding(.top,10)
        .frame(maxHeight: .infinity,alignment: .top)
        .offset(y: showWalkThroughScreens ? 0 : -120)
    }
    
    @ViewBuilder
    func IntroScreen() -> some View{
        GeometryReader{
            let size = $0.size
            
            VStack(spacing: 10){
                Image("Demo1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width,height: size.height * 1/3)
                
                Text("FlightSearch")
                    .font(.system(size: 27))
                    .padding(.top,55)
                
                Text(dummyText)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,30)
                
                Text("Let's Begin")
                    .font(.system(size: 14))
                    .padding(.horizontal,40)
                    .padding(.vertical,14)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(Color("Blue"))
                    }
                    .onTapGesture {
                        showWalkThroughScreens.toggle()
                    }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
            //MARK: Moving up when clicked
            .offset(y: showWalkThroughScreens ? -size.height : 0)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    IntroView()
}

struct LandingPage : View {
    var body: some View {
        NavigationStack{
            Text("Landing Page")
                .navigationTitle("Home")
        }
        
    }
}
