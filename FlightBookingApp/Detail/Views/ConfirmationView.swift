//
//  ConfirmationView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingShareSheet = false
    @State private var showingQRCode = false
    @State private var animateSuccess = false
    @State private var navigateToHome = false
    @State private var navigateToMyTrips = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Sky Blue Fade Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 0.87, green: 0.94, blue: 1.0),
                        Color(red: 0.76, green: 0.89, blue: 0.99)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Hero Section with Animation
                        heroSection
                        
                        // Main Content
                        VStack(spacing: 24) {
                            bookingReferenceSection
                            flightDetailsCard
                            passengerDetailsCard
                            paymentSummaryCard
                            quickActionsSection
                            importantInfoSection
                            nextStepsSection
                        }
                        .padding()
                        
                        // Bottom Actions
                        bottomActionsSection
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                animateSuccess = true
            }
            // Save booking to history
            bookingManager.saveBookingToHistory()
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [createShareText()])
        }
        .sheet(isPresented: $showingQRCode) {
            QRCodeView(
                bookingReference: bookingManager.bookingDetails.bookingReference,
                flight: bookingManager.bookingDetails.outboundFlight
            )
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            ContentView()
        }
        .fullScreenCover(isPresented: $navigateToMyTrips) {
            MyTripsDetailView()
                .environmentObject(bookingManager)
        }
    }
    
    // MARK: - Hero Section
    @ViewBuilder
    private var heroSection: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Animated Success Icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateSuccess ? 1.2 : 0.8)
                    .opacity(animateSuccess ? 1.0 : 0.0)
                
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .scaleEffect(animateSuccess ? 1.0 : 0.5)
                    .opacity(animateSuccess ? 1.0 : 0.0)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                    .scaleEffect(animateSuccess ? 1.0 : 0.5)
                    .rotationEffect(.degrees(animateSuccess ? 0 : -180))
            }
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animateSuccess)
            
            // Success Message
            VStack(spacing: 8) {
                Text("Booking Confirmed! ✈️")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .opacity(animateSuccess ? 1.0 : 0.0)
                    .offset(y: animateSuccess ? 0 : 20)
                
                Text("Your flight has been successfully booked")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(animateSuccess ? 1.0 : 0.0)
                    .offset(y: animateSuccess ? 0 : 20)
            }
            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateSuccess)
            
            Spacer()
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Booking Reference Section
    @ViewBuilder
    private var bookingReferenceSection: some View {
        VStack(spacing: 16) {
            Text("Booking Reference")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bookingManager.bookingDetails.bookingReference)
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                        .textSelection(.enabled)
                    
                    Text("Save this reference number")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = bookingManager.bookingDetails.bookingReference
                    // Show copied feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc")
                        Text("Copy")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    // MARK: - Flight Details Card
    @ViewBuilder
    private var flightDetailsCard: some View {
        if let flight = bookingManager.bookingDetails.outboundFlight {
            VStack(spacing: 20) {
                // Card Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Flight Details")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(flight.company ?? "Airline")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(flight.flightNumber ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                
                // Route Information
                HStack {
                    // Departure
                    VStack(spacing: 8) {
                        Text(flight.sourceCode ?? "DEP")
                            .font(.system(size: 24, weight: .bold))
                        Text(flight.source ?? "Departure")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 2) {
                            Text(flight.departure ?? "00:00")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("Departure")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Flight Path
                    VStack(spacing: 8) {
                        Image(systemName: "airplane")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        Text(flight.duration ?? "2h 30m")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                        
                        Rectangle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(height: 2)
                            .frame(maxWidth: 80)
                            .cornerRadius(1)
                    }
                    
                    Spacer()
                    
                    // Arrival
                    VStack(spacing: 8) {
                        Text(flight.destinationCode ?? "ARR")
                            .font(.system(size: 24, weight: .bold))
                        Text(flight.destination ?? "Arrival")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 2) {
                            Text(flight.arrival ?? "00:00")
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("Arrival")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical)
                
                // Additional Flight Info
                VStack(spacing: 8) {
                    Divider()
                    
                    HStack {
                        Label("Terminal Info", systemImage: "building.2.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Check airport for terminal details")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Label("Aircraft", systemImage: "airplane.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(flight.aircraftType ?? "Boeing 737-800")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Label("Seat Class", systemImage: "chair.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(flight.seatClass ?? "Economy")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    // MARK: - Passenger Details Card
    @ViewBuilder
    private var passengerDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Passenger Details")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(Array(bookingManager.bookingDetails.passengers.enumerated()), id: \.offset) { index, passenger in
                HStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(passenger.title) \(passenger.firstName) \(passenger.lastName)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Adult • \(bookingManager.bookingDetails.outboundFlight?.seatClass ?? "Economy")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Payment Summary Card
    @ViewBuilder
    private var paymentSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                if let flight = bookingManager.bookingDetails.outboundFlight {
                    let baseFare = flight.fare * bookingManager.bookingDetails.passengers.count
                    
                    PaymentRow(label: "Base Fare (\(bookingManager.bookingDetails.passengers.count) passenger\(bookingManager.bookingDetails.passengers.count > 1 ? "s" : ""))", amount: "₹ \(baseFare)")
                    PaymentRow(label: "Taxes & Fees", amount: "₹ 599")
                    PaymentRow(label: "Convenience Fee", amount: "₹ 99")
                    
                    Divider()
                    
                    HStack {
                        Text("Total Paid")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("₹ \(Int(bookingManager.bookingDetails.totalPrice))")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                } else {
                    PaymentRow(label: "Total Amount", amount: "₹ \(Int(bookingManager.bookingDetails.totalPrice))")
                }
                
                HStack {
                    Label("Paid via \(bookingManager.bookingDetails.paymentMethod.capitalized)", systemImage: "creditcard.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Transaction completed successfully")
                        .font(.caption)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Quick Actions Section
    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickActionButton(
                    icon: "qrcode",
                    title: "Show QR Code",
                    subtitle: "Digital boarding pass",
                    color: .blue
                ) {
                    showingQRCode = true
                }
                
                QuickActionButton(
                    icon: "calendar.badge.plus",
                    title: "Add to Calendar",
                    subtitle: "Set reminders",
                    color: .green
                ) {
                    addToCalendar()
                }
                
                QuickActionButton(
                    icon: "square.and.arrow.up",
                    title: "Share Details",
                    subtitle: "Send to others",
                    color: .orange
                ) {
                    showingShareSheet = true
                }
                
                QuickActionButton(
                    icon: "doc.text",
                    title: "Download Ticket",
                    subtitle: "Save as PDF",
                    color: .purple
                ) {
                    downloadTicket()
                }
            }
        }
    }
    
    // MARK: - Important Info Section
    @ViewBuilder
    private var importantInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Important Information")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 8) {
                ImportantInfoRow(
                    icon: "clock.fill",
                    text: "Arrive 2 hours before domestic flights",
                    color: .blue
                )
                
                ImportantInfoRow(
                    icon: "person.text.rectangle.fill",
                    text: "Carry valid government-issued photo ID",
                    color: .purple
                )
                
                ImportantInfoRow(
                    icon: "suitcase.fill",
                    text: "Check baggage allowance: \(bookingManager.bookingDetails.outboundFlight?.checkin ?? "15kg") included",
                    color: .green
                )
                
                ImportantInfoRow(
                    icon: "wifi",
                    text: "Web check-in opens 48 hours before departure",
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: Color.orange.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Next Steps Section
    @ViewBuilder
    private var nextStepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What's Next?")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                NextStepRow(
                    number: 1,
                    title: "Check-in Online",
                    subtitle: "Available 48 hours before departure",
                    timeframe: "2 days before"
                )
                
                NextStepRow(
                    number: 2,
                    title: "Arrive at Airport",
                    subtitle: "Be there 2 hours early for smooth boarding",
                    timeframe: "Day of travel"
                )
                
                NextStepRow(
                    number: 3,
                    title: "Board Your Flight",
                    subtitle: "Gates usually open 45 minutes before departure",
                    timeframe: "Departure time"
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Bottom Actions Section
    @ViewBuilder
    private var bottomActionsSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                navigateToMyTrips = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "airplane.circle.fill")
                    Text("View My Bookings")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            
            Button(action: {
                navigateToHome = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Book Another Flight")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.clear)
                .foregroundColor(.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
            }
            
            // Support Contact
            HStack(spacing: 8) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.green)
                Text("Need help? Call us at +91 12345 67890")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    
    private func createShareText() -> String {
        guard let flight = bookingManager.bookingDetails.outboundFlight else {
            return "Flight booking confirmed! Reference: \(bookingManager.bookingDetails.bookingReference)"
        }
        
        return """
        ✈️ Flight Booking Confirmed!
        
        📋 Booking Reference: \(bookingManager.bookingDetails.bookingReference)
        ✈️ Flight: \(flight.flightNumber ?? "") (\(flight.company ?? ""))
        📍 Route: \(flight.sourceCode ?? "") → \(flight.destinationCode ?? "")
        🕐 Departure: \(flight.departure ?? "")
        🕐 Arrival: \(flight.arrival ?? "")
        💰 Total: ₹\(Int(bookingManager.bookingDetails.totalPrice))
        
        Have a great trip! 🌟
        """
    }
    
    private func addToCalendar() {
        // Implement calendar integration
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        // You can implement EventKit integration here
    }
    
    private func downloadTicket() {
        // Implement PDF generation and download
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        // You can implement PDF generation here
    }
}

// MARK: - Supporting Components

struct PaymentRow: View {
    let label: String
    let amount: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(amount)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 80)
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ImportantInfoRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct NextStepRow: View {
    let number: Int
    let title: String
    let subtitle: String
    let timeframe: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue)
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(number)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(timeframe)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(8)
        }
    }
}

// MARK: - Enhanced QR Code View
struct QRCodeView: View {
    let bookingReference: String
    let flight: Flight?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Digital Boarding Pass")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Enhanced QR Code with boarding pass design
                VStack(spacing: 16) {
                    // QR Code
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .frame(width: 200, height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "qrcode")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                Text("QR Code")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        )
                    
                    // Boarding pass info
                    VStack(spacing: 8) {
                        Text(bookingReference)
                            .font(.system(.title2, design: .monospaced))
                            .fontWeight(.bold)
                        
                        if let flight = flight {
                            HStack {
                                VStack {
                                    Text(flight.sourceCode ?? "")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text(flight.departure ?? "")
                                        .font(.caption)
                                }
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.blue)
                                
                                VStack {
                                    Text(flight.destinationCode ?? "")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text(flight.arrival ?? "")
                                        .font(.caption)
                                }
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                
                Text("Show this QR code at security and boarding")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    // Implement save to photos
                }
            )
        }
    }
}



// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
