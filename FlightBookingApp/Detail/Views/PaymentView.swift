//
//  PaymentView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct PaymentView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @Environment(\.presentationMode) var presentationMode
    
    // Screen dimensions (passed from parent view or default)
    var size: CGSize
    var safearea: EdgeInsets
    
    // Payment form states
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var selectedPaymentMethod = "credit_card"
    @State private var promoCode = ""
    @State private var isPromoApplied = false
    @State private var savePaymentMethod = false
    @State private var acceptPaymentTerms = false
    @State private var receiptMethod = "email"
    
    // Animation states
    @State private var showPaymentAnimation = false
    @State private var showingConfirmation = false
    @StateObject var animator: Animator = .init()
    
    var totalPrice: Double {
        guard let flight = bookingManager.bookingDetails.outboundFlight else { return 0 }
        let basePrice = Double(flight.fare) * Double(bookingManager.bookingDetails.passengers.count)
        return isPromoApplied ? basePrice * 0.9 : basePrice // 10% discount if promo applied
    }
    
    var body: some View {
        ZStack {
            if !showPaymentAnimation {
                // Payment Form Content
                paymentFormContent
            } else {
                // Flight Animation View
                flightAnimationView
            }
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showingConfirmation) {
            ConfirmationView()
                .environmentObject(bookingManager)
        }
        .onChange(of: animator.showFinalView) { newValue in
            if newValue {
                showingConfirmation = true
            }
        }
    }
    
    // MARK: - Payment Form Content
    @ViewBuilder
    private var paymentFormContent: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    bookingSummarySection
                    paymentMethodsSection
                    paymentFormSection
                    promoCodeSection
                    receiptOptionsSection
                    securitySection
                    termsSection
                    payButton
                    supportSection
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Flight Animation View
    @ViewBuilder
    private var flightAnimationView: some View {
        VStack(spacing: 0) {
            AnimationHeaderView()
                .offset(x: animator.startAnimation ? 300 : 0)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(content: {
            ZStack(alignment: .bottom) {
                ZStack {
                    if animator.showClouds {
                        Group {
                            CloudView(delay: 1, size: size)
                                .offset(y: size.height * -0.1)
                            CloudView(delay: 0, size: size)
                                .offset(y: size.height * 0.3)
                            CloudView(delay: 2.5, size: size)
                                .offset(y: size.height * 0.2)
                            CloudView(delay: 2.5, size: size)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                if animator.showLoadingView {
                    PaymentStatusView(size: size, animator: animator)
                        .transition(.scale)
                }
            }
        })
        .overlayPreferenceValue(ReactKey.self, { value in
            if let anchor = value["PLANEBOUNDS"] {
                GeometryReader { proxy in
                    let rect = proxy[anchor]
                    let planeRect = animator.initalPlanePosition
                    let status = animator.currentPaymentStatus
                    let animationStatus = status == .finished && !animator.showFinalView
                    
                    Image("Airplane3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: planeRect.width, height: planeRect.height)
                        .rotationEffect(.init(degrees: animationStatus ? -10 : 0))
                        .shadow(color: .black.opacity(0.25), radius: 1, x: status == .finished ? -400 : 0, y: status == .finished ? 170 : 0)
                        .offset(x: planeRect.minX, y: planeRect.minY)
                        .offset(y: animator.startAnimation ? 50 : 0)
                        .onAppear {
                            animator.initalPlanePosition = rect
                        }
                        .animation(.easeIn(duration: animationStatus ? 3.5 : 2.5), value: animationStatus)
                }
            }
        })
        .overlay(content: {
            if animator.showClouds {
                CloudView(delay: 2.2, size: size)
                    .offset(y: -size.height * 0.25)
            }
        })
        .background {
            Color(.lightGray)
                .opacity(0.5)
                .ignoresSafeArea()
        }
        .onChange(of: animator.currentPaymentStatus) { newValue in
            if newValue == .finished {
                animator.showClouds = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 9.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    animator.showFinalView = true
                }
            }
        }
    }
    
    // MARK: - Animation Header View
    @ViewBuilder
    func AnimationHeaderView() -> some View {
        VStack {
            Image("Airplane3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 160)
                .opacity(0)
                .anchorPreference(key: ReactKey.self, value: .bounds, transform: { anchor in
                    return ["PLANEBOUNDS": anchor]
                })
                .padding(.bottom, -20)
                .rotationEffect(.degrees(360))
        }
        .padding([.horizontal, .top], 15)
        .padding(.top, safearea.top)
        .rotation3DEffect(.init(degrees: animator.startAnimation ? 90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.8))
        .offset(y: animator.startAnimation ? -100 : 0)
    }
    
    // MARK: - Flight Details View
    @ViewBuilder
    func FlightDetailsView(alignment: HorizontalAlignment = .leading, place: String, code: String, timing: String) -> some View {
        VStack(alignment: alignment, spacing: 6) {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            
            Text(timing)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Payment")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Complete your booking")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Booking Summary Section
    @ViewBuilder
    private var bookingSummarySection: some View {
        BookingSummaryCard(totalPrice: totalPrice, isPromoApplied: isPromoApplied)
    }
    
    // MARK: - Payment Methods Section
    @ViewBuilder
    private var paymentMethodsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Method")
                .font(.headline)
            
            HStack(spacing: 16) {
                PaymentMethodButton(
                    icon: "creditcard.fill",
                    title: "Card",
                    isSelected: selectedPaymentMethod == "credit_card"
                ) {
                    selectedPaymentMethod = "credit_card"
                }
                
                PaymentMethodButton(
                    icon: "dollarsign.circle.fill",
                    title: "UPI",
                    isSelected: selectedPaymentMethod == "upi"
                ) {
                    selectedPaymentMethod = "upi"
                }
                
                PaymentMethodButton(
                    icon: "building.columns.fill",
                    title: "Net Banking",
                    isSelected: selectedPaymentMethod == "netbanking"
                ) {
                    selectedPaymentMethod = "netbanking"
                }
                
                PaymentMethodButton(
                    icon: "wallet.pass.fill",
                    title: "Wallet",
                    isSelected: selectedPaymentMethod == "wallet"
                ) {
                    selectedPaymentMethod = "wallet"
                }
            }
        }
    }
    
    // MARK: - Payment Form Section
    @ViewBuilder
    private var paymentFormSection: some View {
        if selectedPaymentMethod == "credit_card" {
            VStack(spacing: 16) {
                Text("Card Information")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 12) {
                    TextField("Cardholder Name", text: $cardholderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Card Number", text: $cardNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    HStack(spacing: 12) {
                        TextField("MM/YY", text: $expiryDate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("CVV", text: $cvv)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Toggle("Save this card for future payments", isOn: $savePaymentMethod)
                        Spacer()
                    }
                    .font(.subheadline)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Promo Code Section
    @ViewBuilder
    private var promoCodeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Promo Code")
                .font(.headline)
            
            HStack {
                TextField("Enter promo code", text: $promoCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Apply") {
                    applyPromoCode()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(promoCode.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(promoCode.isEmpty)
            }
            
            if isPromoApplied {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Promo code applied! You saved ₹\(Int(totalPrice * 0.1))")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Receipt Options Section
    @ViewBuilder
    private var receiptOptionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Receipt Delivery")
                .font(.headline)
            
            Picker("Receipt Method", selection: $receiptMethod) {
                Label("Email", systemImage: "envelope.fill").tag("email")
                Label("SMS", systemImage: "message.fill").tag("sms")
                Label("Both", systemImage: "paperplane.fill").tag("both")
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Security Section
    @ViewBuilder
    private var securitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Security & Trust")
                .font(.headline)
            
            HStack(spacing: 20) {
                SecurityBadge(icon: "lock.shield.fill", text: "SSL Secured")
                SecurityBadge(icon: "creditcard.and.123", text: "PCI Compliant")
                SecurityBadge(icon: "checkmark.shield.fill", text: "256-bit Encryption")
            }
            
            Text("Your payment information is secure and encrypted. We do not store your card details.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Terms Section
    @ViewBuilder
    private var termsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Button(action: {
                    acceptPaymentTerms.toggle()
                }) {
                    Image(systemName: acceptPaymentTerms ? "checkmark.square.fill" : "square")
                        .foregroundColor(acceptPaymentTerms ? .blue : .gray)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("I agree to the payment terms and conditions")
                        .font(.subheadline)
                    
                    HStack {
                        Button("Payment Terms") {
                            // Show payment terms
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Button("Refund Policy") {
                            // Show refund policy
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Label("Free cancellation within 24 hours", systemImage: "clock.arrow.circlepath")
                Label("Full refund for flight cancellations by airline", systemImage: "airplane.departure")
                Label("Processing fee of ₹99 is non-refundable", systemImage: "info.circle.fill")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Pay Button
    @ViewBuilder
    private var payButton: some View {
        Button(action: processPayment) {
            HStack {
                Image(systemName: "lock.fill")
                Text("Pay ₹\(Int(totalPrice))")
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isFormValid ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - Support Section
    @ViewBuilder
    private var supportSection: some View {
        VStack(spacing: 12) {
            Text("Need Help?")
                .font(.headline)
            
            HStack(spacing: 20) {
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                        Text("Call Support")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
                
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "message.fill")
                            .font(.title2)
                        Text("Live Chat")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
                
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "envelope.fill")
                            .font(.title2)
                        Text("Email Us")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        if selectedPaymentMethod == "credit_card" {
            return !cardholderName.isEmpty &&
                   cardNumber.count >= 16 &&
                   !expiryDate.isEmpty &&
                   cvv.count >= 3 &&
                   acceptPaymentTerms
        }
        return acceptPaymentTerms
    }
    
    // MARK: - Methods
    private func applyPromoCode() {
        if promoCode.lowercased() == "save10" {
            isPromoApplied = true
        }
    }
    
    private func processPayment() {
        // Set booking details
        bookingManager.bookingDetails.totalPrice = totalPrice
        bookingManager.bookingDetails.bookingReference = bookingManager.generateBookingReference()
        
        // Start the flight animation sequence
        withAnimation(.easeInOut(duration: 0.8)) {
            showPaymentAnimation = true
        }
        
        // Trigger the plane animation after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            movePlane()
        }
    }
    
    func movePlane() {
        withAnimation(.easeInOut(duration: 0.85)) {
            animator.startAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.7)) {
                animator.showLoadingView = true
            }
        }
    }
}

// MARK: - Supporting Animation Components

struct PaymentStatusView: View {
    let size: CGSize
    @ObservedObject var animator: Animator
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                ForEach(PaymentStatus.allCases, id: \.rawValue) { status in
                    Text(status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(height: 30)
                }
            }
            .offset(y: animator.currentPaymentStatus == .started ? -30 : animator.currentPaymentStatus == .finished ? -60 : 0)
            .frame(height: 30, alignment: .top)
            .clipped()
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.05))
                    .shadow(color: .black.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[0] ? 5 : 1)
                    .opacity(animator.ringAnimation[0] ? 0 : 1)
                
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .shadow(color: .black.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[1] ? 5 : 1)
                    .opacity(animator.ringAnimation[1] ? 0 : 1)
                
                Circle()
                    .fill(Color.gray.opacity(0.15))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.1), radius: 5, x: -5, y: -5)
                    .scaleEffect(1.22)
                
                Circle()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                
                Image(systemName: animator.currentPaymentStatus.symbolImage)
                    .font(.largeTitle)
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(width: 80, height: 80)
            .padding(.top, 20)
            .zIndex(0)
        }
        .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect()) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                if animator.currentPaymentStatus == .initated {
                    animator.currentPaymentStatus = .started
                } else {
                    animator.currentPaymentStatus = .finished
                }
            }
        }
        .onAppear(perform: {
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                animator.ringAnimation[0] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    animator.ringAnimation[1] = true
                }
            }
        })
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, size.height * 0.15)
    }
}

struct CloudView: View {
    var delay: Double
    var size: CGSize
    @State private var moveCloud: Bool = false
    
    var body: some View {
        ZStack {
            Image("cloud2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: moveCloud ? -size.width * 2 : size.width * 2)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 6.5).delay(delay)) {
                moveCloud.toggle()
            }
        }
    }
}

// MARK: - Existing Components (unchanged)

struct PaymentMethodButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : .blue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.blue : Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct SecurityBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.green)
            Text(text)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BookingSummaryCard: View {
    let totalPrice: Double
    let isPromoApplied: Bool
    @EnvironmentObject var bookingManager: BookingManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Booking Summary")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let flight = bookingManager.bookingDetails.outboundFlight {
                VStack(spacing: 12) {
                    HStack {
                        Text("Flight")
                        Spacer()
                        Text("\(flight.sourceCode) → \(flight.destinationCode)")
                    }
                    
                    HStack {
                        Text("Airline")
                        Spacer()
                        Text(flight.company ?? "")
                    }
                    
                    HStack {
                        Text("Passengers")
                        Spacer()
                        Text("\(bookingManager.bookingDetails.passengers.count)")
                    }
                    
                    HStack {
                        Text("Base Fare")
                        Spacer()
                        Text("₹ \(Int(Double(flight.fare) * Double(bookingManager.bookingDetails.passengers.count)))")
                    }
                    
                    HStack {
                        Text("Taxes & Fees")
                        Spacer()
                        Text("₹ 599")
                    }
                    
                    if isPromoApplied {
                        HStack {
                            Text("Discount (10%)")
                            Spacer()
                            Text("- ₹ \(Int(totalPrice * 0.1))")
                                .foregroundColor(.green)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("₹ \(Int(totalPrice))")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Classes and Enums

class Animator: ObservableObject {
    @Published var startAnimation: Bool = false
    @Published var initalPlanePosition: CGRect = .zero
    @Published var currentPaymentStatus: PaymentStatus = .initated
    @Published var ringAnimation: [Bool] = [false, false]
    @Published var showLoadingView: Bool = false
    @Published var showClouds: Bool = false
    @Published var showFinalView: Bool = false
}

struct ReactKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
