//
//  Flight.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import Foundation

struct Flight: Identifiable, Codable, Equatable {
    let id: Int
    let flightNumber: String?
    let company: String?
    let source: String?
    let sourceCode: String?
    let sourceAirport: String?
    let destination: String?
    let destinationCode: String?
    let destinationAirport: String?
    let departure: String?
    let arrival: String?
    let duration: String?
    let fare: Int
    let checkin: String?
    let cabin: String?
    let cancellation: String?
    
    // Additional properties for enhanced functionality
    var departureDate: Date?
    var arrivalDate: Date?
    var aircraftType: String?
    var seatClass: String?
    var availableSeats: Int?
    var amenities: [String]?
    
    // Equatable conformance
    static func == (lhs: Flight, rhs: Flight) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: Int, flightNumber: String?, company: String?, source: String?, sourceCode: String?, sourceAirport: String?, destination: String?, destinationCode: String?, destinationAirport: String?, departure: String?, arrival: String?, duration: String?, fare: Int, checkin: String?, cabin: String?, cancellation: String?) {
        self.id = id
        self.flightNumber = flightNumber
        self.company = company
        self.source = source
        self.sourceCode = sourceCode
        self.sourceAirport = sourceAirport
        self.destination = destination
        self.destinationCode = destinationCode
        self.destinationAirport = destinationAirport
        self.departure = departure
        self.arrival = arrival
        self.duration = duration
        self.fare = fare
        self.checkin = checkin
        self.cabin = cabin
        self.cancellation = cancellation
        
        // Default values for enhanced properties
        self.departureDate = Date()
        self.arrivalDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
        self.aircraftType = "Boeing 737-800"
        self.seatClass = "Economy"
        self.availableSeats = Int.random(in: 10...50)
        self.amenities = ["WiFi", "Meals", "Entertainment"]
    }
    
    // Convenience initializer with minimal parameters
    init() {
        self.id = 0
        self.flightNumber = "AI 101"
        self.company = "Air India"
        self.source = "Delhi"
        self.sourceCode = "DEL"
        self.sourceAirport = "Indira Gandhi International Airport"
        self.destination = "Mumbai"
        self.destinationCode = "BOM"
        self.destinationAirport = "Chhatrapati Shivaji International Airport"
        self.departure = "06:30"
        self.arrival = "08:45"
        self.duration = "2h 15m"
        self.fare = 4500
        self.checkin = "15 kg"
        self.cabin = "7 kg"
        self.cancellation = "Free cancellation up to 24 hours before departure"
        
        // Default values for enhanced properties
        self.departureDate = Date()
        self.arrivalDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
        self.aircraftType = "Boeing 737-800"
        self.seatClass = "Economy"
        self.availableSeats = Int.random(in: 10...50)
        self.amenities = ["WiFi", "Meals", "Entertainment"]
    }
}
