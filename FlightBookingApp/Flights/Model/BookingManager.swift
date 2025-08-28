//
//  BookingManager.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI
import Foundation

// MARK: - Enhanced BookingManager
class BookingManager: ObservableObject {
    @Published var bookingDetails = BookingDetails()
    @Published var currentStep: BookingStep = .search
    @Published var selectedFlight: Flight?
    @Published var searchResults: [Flight] = []
    
    enum BookingStep {
        case search, results, passengerDetails, payment, confirmation
    }
    
    func generateBookingReference() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        
        let randomLetters = String((0..<3).map { _ in letters.randomElement()! })
        let randomNumbers = String((0..<4).map { _ in numbers.randomElement()! })
        
        return randomLetters + randomNumbers
    }
    
    // MARK: - Additional Helper Methods
    func selectFlight(_ flight: Flight) {
        selectedFlight = flight
        bookingDetails.outboundFlight = flight
        currentStep = .passengerDetails
    }
    
    func calculateTotalPrice() -> Double {
        guard let flight = selectedFlight else { return 0.0 }
        let baseFare = Double(flight.fare) * Double(bookingDetails.passengers.count)
        let taxes = 599.0
        let convenienceFee = 99.0
        return baseFare + taxes + convenienceFee
    }
    
    func proceedToPayment() {
        bookingDetails.totalPrice = calculateTotalPrice()
        currentStep = .payment
    }
    
    func completeBooking() {
        bookingDetails.bookingReference = generateBookingReference()
        bookingDetails.totalPrice = calculateTotalPrice()
        currentStep = .confirmation
    }
    
    // MARK: - Search Methods
    func searchFlights(from: String, to: String, date: Date, passengers: Int) {
        // This would normally make an API call
        // For now, we'll use sample data
        searchResults = generateSampleFlights(from: from, to: to, passengers: passengers)
        currentStep = .results
    }
    
    private func generateSampleFlights(from: String, to: String, passengers: Int) -> [Flight] {
        let airlines = ["IndiGo", "Air India", "SpiceJet", "GoAir", "Vistara"]
        let flightPrefixes = ["6E", "AI", "SG", "G8", "UK"]
        
        return (1...5).map { index in
            Flight(
                id: index,
                flightNumber: "\(flightPrefixes[index-1])\(String(format: "%04d", Int.random(in: 1000...9999)))",
                company: airlines[index-1],
                source: from,
                sourceCode: String(from.prefix(3)).uppercased(),
                sourceAirport: "\(from) International Airport",
                destination: to,
                destinationCode: String(to.prefix(3)).uppercased(),
                destinationAirport: "\(to) International Airport",
                departure: "0\(index + 5):30",
                arrival: "0\(index + 7):45",
                duration: "2h 15m",
                fare: Int.random(in: 3000...8000),
                checkin: "15 kg",
                cabin: "7 kg",
                cancellation: "Free cancellation up to 24 hours before departure"
            )
        }
    }
}

// MARK: - Enhanced BookingDetails
struct BookingDetails {
    var passengers: [Passenger] = []
    var contactEmail: String = ""
    var contactPhone: String = ""
    var emergencyContactName: String = ""
    var emergencyContactPhone: String = ""
    var specialRequirements: String = ""
    var outboundFlight: Flight?
    var returnFlight: Flight? // For round trips
    var totalPrice: Double = 0.0
    var bookingReference: String = ""
    var bookingDate: Date = Date()
    var paymentMethod: String = "credit_card"
    var isRoundTrip: Bool = false
}

// MARK: - Enhanced Passenger Model
struct Passenger: Identifiable {
    let id = UUID()
    var title: String = "Mr."
    var firstName: String = ""
    var lastName: String = ""
    var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    var gender: String = "Male"
    var nationality: String = "Indian"
    var passportNumber: String = ""
    var passportExpiry: Date = Calendar.current.date(byAdding: .year, value: 10, to: Date()) ?? Date()
    var specialRequests: [String] = []
    
    var fullName: String {
        return "\(title) \(firstName) \(lastName)"
    }
    
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return ageComponents.year ?? 0
    }
}

// MARK: - Search Parameters Model
struct FlightSearchParams {
    var fromCity: String = ""
    var toCity: String = ""
    var departureDate: Date = Date()
    var returnDate: Date?
    var passengers: Int = 1
    var isRoundTrip: Bool = false
    var preferredClass: String = "Economy"
    var flexibleDates: Bool = false
}

// MARK: - Payment Information Model
struct PaymentInfo {
    var cardNumber: String = ""
    var cardholderName: String = ""
    var expiryDate: String = ""
    var cvv: String = ""
    var billingAddress: String = ""
    var paymentMethod: String = "credit_card"
    var saveCard: Bool = false
}

// MARK: - Booking Manager Extensions
extension BookingManager {
    
    // MARK: - Validation Methods
    func validatePassengerDetails() -> Bool {
        return !bookingDetails.passengers.isEmpty &&
               bookingDetails.passengers.allSatisfy { !$0.firstName.isEmpty && !$0.lastName.isEmpty } &&
               !bookingDetails.contactEmail.isEmpty &&
               !bookingDetails.contactPhone.isEmpty
    }
    
    func validatePaymentInfo(_ paymentInfo: PaymentInfo) -> Bool {
        return !paymentInfo.cardholderName.isEmpty &&
               paymentInfo.cardNumber.count >= 16 &&
               !paymentInfo.expiryDate.isEmpty &&
               paymentInfo.cvv.count >= 3
    }
    
    // MARK: - Data Management
    func addPassenger() {
        bookingDetails.passengers.append(Passenger())
    }
    
    func removePassenger(at index: Int) {
        guard index < bookingDetails.passengers.count else { return }
        bookingDetails.passengers.remove(at: index)
    }
    
    func updatePassenger(at index: Int, passenger: Passenger) {
        guard index < bookingDetails.passengers.count else { return }
        bookingDetails.passengers[index] = passenger
    }
    
    // MARK: - Booking History (for future implementation)
    func saveBookingToHistory() {
        // This would save to UserDefaults or Core Data
        // For now, we'll just store the booking reference
        let bookingHistory = UserDefaults.standard.stringArray(forKey: "BookingHistory") ?? []
        var updatedHistory = bookingHistory
        updatedHistory.append(bookingDetails.bookingReference)
        UserDefaults.standard.set(updatedHistory, forKey: "BookingHistory")
    }
    
    func getBookingHistory() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "BookingHistory") ?? []
    }
    
    // MARK: - Reset Methods
    func resetBooking() {
        bookingDetails = BookingDetails()
        selectedFlight = nil
        searchResults = []
        currentStep = .search
    }
    
    func startNewSearch() {
        selectedFlight = nil
        searchResults = []
        currentStep = .search
    }
}

// MARK: - Sample Data for Testing
extension BookingManager {
    static func createSampleBooking() -> BookingManager {
        let manager = BookingManager()
        
        // Add sample flight
        let sampleFlight = Flight(
            id: 1,
            flightNumber: "6E-2024",
            company: "IndiGo",
            source: "Mumbai",
            sourceCode: "BOM",
            sourceAirport: "Chhatrapati Shivaji Maharaj International Airport",
            destination: "Delhi",
            destinationCode: "DEL",
            destinationAirport: "Indira Gandhi International Airport",
            departure: "06:30",
            arrival: "08:45",
            duration: "2h 15m",
            fare: 4500,
            checkin: "15 kg",
            cabin: "7 kg",
            cancellation: "Free cancellation up to 24 hours before departure"
        )
        
        manager.selectedFlight = sampleFlight
        manager.bookingDetails.outboundFlight = sampleFlight
        
        // Add sample passenger
        var samplePassenger = Passenger()
        samplePassenger.title = "Mr."
        samplePassenger.firstName = "John"
        samplePassenger.lastName = "Doe"
        manager.bookingDetails.passengers = [samplePassenger]
        
        // Add sample contact info
        manager.bookingDetails.contactEmail = "john.doe@example.com"
        manager.bookingDetails.contactPhone = "+91 9876543210"
        
        return manager
    }
}
