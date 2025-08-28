//
//  PassengersDetailsView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct PassengerDetailsView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @Environment(\.presentationMode) var presentationMode
    
    let passengerCount: Int
    @State private var passengers: [Passenger] = []
    @State private var showingPayment = false
    
    // Contact and additional details
    @State private var contactEmail = ""
    @State private var contactPhone = ""
    @State private var emergencyContactName = ""
    @State private var emergencyContactPhone = ""
    @State private var specialRequirements = ""
    @State private var acceptTerms = false
    @State private var subscribeNewsletter = false
    
    // Special requirements toggles
    @State private var wheelchairAssistance = false
    @State private var vegetarianMeal = false
    @State private var extraLegroom = false
    @State private var medicalAssistance = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Sky Blue Fade background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 0.87, green: 0.94, blue: 1.0),
                        Color(red: 0.76, green: 0.89, blue: 0.99)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Header
                    headerView
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 24) {
                            titleSection
                            passengersSection
                            contactInfoSection
                            emergencyContactSection
                            specialRequirementsSection
                            bookingSummarySection
                            termsSection
                            importantRemindersSection
                            continueButton
                            Spacer(minLength: 20)
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            initializePassengers()
        }
        .fullScreenCover(isPresented: $showingPayment) {
            PaymentView(
                size: UIScreen.main.bounds.size,
                safearea: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            )
            .environmentObject(bookingManager)
        }
    }
    
    // MARK: - Custom Header
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text("Passenger Details")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Spacer()
            
            // Balance space
            Color.clear
                .frame(width: 32, height: 32)
        }
        .padding()
        .background(Color.clear)
    }
    
    // MARK: - Title Section
    @ViewBuilder
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enter Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Please provide information for all passengers")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Passengers Section
    @ViewBuilder
    private var passengersSection: some View {
        ForEach(Array(passengers.enumerated()), id: \.offset) { index, passenger in
            PassengerForm(
                passenger: $passengers[index],
                passengerNumber: index + 1
            )
        }
    }
    
    // MARK: - Contact Info Section
    @ViewBuilder
    private var contactInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contact Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email Address *")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter email for booking confirmation", text: $contactEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number *")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Enter phone number", text: $contactPhone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                }
                
                Text("We'll send booking confirmation and flight updates to this email and phone number.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Emergency Contact Section
    @ViewBuilder
    private var emergencyContactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emergency Contact")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Emergency contact name", text: $emergencyContactName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("Emergency contact phone", text: $emergencyContactPhone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Special Requirements Section
    @ViewBuilder
    private var specialRequirementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Special Requirements")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                SpecialRequirementRow(
                    icon: "figure.roll",
                    text: "Wheelchair Assistance",
                    isSelected: $wheelchairAssistance
                )
                
                SpecialRequirementRow(
                    icon: "leaf.fill",
                    text: "Vegetarian Meal",
                    isSelected: $vegetarianMeal
                )
                
                SpecialRequirementRow(
                    icon: "person.crop.circle.badge.plus",
                    text: "Extra Legroom",
                    isSelected: $extraLegroom
                )
                
                SpecialRequirementRow(
                    icon: "heart.fill",
                    text: "Medical Assistance",
                    isSelected: $medicalAssistance
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Additional Requests")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("Any other special requirements...", text: $specialRequirements, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Booking Summary Section
    @ViewBuilder
    private var bookingSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Booking Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            summaryRows
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: Color.blue.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private var summaryRows: some View {
        VStack(spacing: 12) {
            // Flight details row
            if let flight = bookingManager.bookingDetails.outboundFlight {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Flight \(flight.flightNumber ?? "AI 101")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(flight.sourceCode ?? "DEL") → \(flight.destinationCode ?? "BOM")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("\(flight.departure ?? "06:30") - \(flight.arrival ?? "08:45")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            HStack {
                Text("Flight Fare (\(passengerCount) passenger\(passengerCount > 1 ? "s" : ""))")
                Spacer()
                Text("₹ \(getFlightFare())")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("Taxes & Fees")
                Spacer()
                Text("₹ 599")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("Convenience Fee")
                Spacer()
                Text("₹ 99")
                    .fontWeight(.medium)
            }
            
            // Add-on services
            if extraLegroom {
                HStack {
                    Text("Extra Legroom")
                    Spacer()
                    Text("₹ 500")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            
            if vegetarianMeal {
                HStack {
                    Text("Special Meal")
                    Spacer()
                    Text("₹ 200")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            
            Divider()
            
            HStack {
                Text("Total Amount")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("₹ \(totalAmount)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Terms Section
    @ViewBuilder
    private var termsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            termsCheckbox
            newsletterCheckbox
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private var termsCheckbox: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: {
                acceptTerms.toggle()
            }) {
                Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                    .foregroundColor(acceptTerms ? .blue : .gray)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("I accept the Terms & Conditions and Privacy Policy *")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 8) {
                    Button("Terms & Conditions") {
                        // Show terms
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button("Privacy Policy") {
                        // Show privacy policy
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
        }
    }
    
    @ViewBuilder
    private var newsletterCheckbox: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: {
                subscribeNewsletter.toggle()
            }) {
                Image(systemName: subscribeNewsletter ? "checkmark.square.fill" : "square")
                    .foregroundColor(subscribeNewsletter ? .blue : .gray)
                    .font(.title3)
            }
            
            Text("Subscribe to newsletter for exclusive deals and updates")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Important Reminders Section
    @ViewBuilder
    private var importantRemindersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Important Reminders")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 8) {
                ImportantReminderRow(
                    icon: "clock.fill",
                    text: "Arrive at airport 2 hours before domestic flights"
                )
                ImportantReminderRow(
                    icon: "person.text.rectangle.fill",
                    text: "Carry valid government-issued photo ID"
                )
                ImportantReminderRow(
                    icon: "suitcase.fill",
                    text: "Check baggage allowance before packing"
                )
                ImportantReminderRow(
                    icon: "checkmark.circle.fill",
                    text: "Web check-in opens 48 hours before departure"
                )
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: Color.orange.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Continue Button
    @ViewBuilder
    private var continueButton: some View {
        Button(action: continueToPayment) {
            HStack(spacing: 8) {
                Text("Continue to Payment")
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right.circle.fill")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: allDetailsValid ? [Color.blue, Color.blue.opacity(0.8)] : [Color.gray, Color.gray.opacity(0.8)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: allDetailsValid ? Color.blue.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .disabled(!allDetailsValid)
        .scaleEffect(allDetailsValid ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.2), value: allDetailsValid)
    }
    
    // MARK: - Computed Properties
    private var totalAmount: Int {
        var total = getFlightFare() + 599 + 99 // Base + taxes + convenience fee
        
        // Add special services
        if extraLegroom { total += 500 }
        if vegetarianMeal { total += 200 }
        
        return total
    }
    
    private func getFlightFare() -> Int {
        if let flight = bookingManager.bookingDetails.outboundFlight {
            return flight.fare * passengerCount
        }
        return 5000 * passengerCount // Default fare if no flight selected
    }
    
    private var allDetailsValid: Bool {
        let passengersValid = passengers.allSatisfy { passenger in
            !passenger.firstName.isEmpty && !passenger.lastName.isEmpty
        }
        let contactValid = !contactEmail.isEmpty && !contactPhone.isEmpty && isValidEmail(contactEmail)
        return passengersValid && contactValid && acceptTerms
    }
    
    // MARK: - Helper Methods
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func initializePassengers() {
        if passengers.isEmpty {
            passengers = Array(0..<passengerCount).map { _ in Passenger() }
        }
    }
    
    private func continueToPayment() {
        // Save all passenger and contact details to booking manager
        bookingManager.bookingDetails.passengers = passengers
        bookingManager.bookingDetails.contactEmail = contactEmail
        bookingManager.bookingDetails.contactPhone = contactPhone
        bookingManager.bookingDetails.emergencyContactName = emergencyContactName
        bookingManager.bookingDetails.emergencyContactPhone = emergencyContactPhone
        bookingManager.bookingDetails.specialRequirements = specialRequirements
        
        // Update total price including add-ons
        bookingManager.bookingDetails.totalPrice = Double(totalAmount)
        
        showingPayment = true
    }
}

// MARK: - Supporting Components

struct SpecialRequirementRow: View {
    let icon: String
    let text: String
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isSelected ? .blue : .gray)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Toggle("", isOn: $isSelected)
                .scaleEffect(0.9)
        }
        .padding(.vertical, 4)
    }
}

struct ImportantReminderRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 16)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

struct PassengerForm: View {
    @Binding var passenger: Passenger
    let passengerNumber: Int
    
    let titles = ["Mr.", "Mrs.", "Ms.", "Dr."]
    
    var body: some View {
        VStack(spacing: 16) {
            // Passenger Number Header
            HStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text("\(passengerNumber)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Passenger \(passengerNumber)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Adult • Economy")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("Required")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(6)
            }
            
            titlePicker
            nameFields
            dateOfBirthPicker
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private var titlePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title *")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Picker("Title", selection: $passenger.title) {
                ForEach(titles, id: \.self) { title in
                    Text(title).tag(title)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    @ViewBuilder
    private var nameFields: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("First Name *")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("Enter first name", text: $passenger.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Last Name *")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("Enter last name", text: $passenger.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
            }
        }
    }
    
    @ViewBuilder
    private var dateOfBirthPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date of Birth *")
                .font(.subheadline)
                .fontWeight(.medium)
            
            DatePicker("", selection: $passenger.dateOfBirth, displayedComponents: .date)
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
                .datePickerStyle(CompactDatePickerStyle())
        }
    }
}
