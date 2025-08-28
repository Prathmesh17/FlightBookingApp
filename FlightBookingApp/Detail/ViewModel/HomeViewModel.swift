//
//  HomeViewModel.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Supporting Models

struct PopularDestination: Identifiable, Codable {
    let id = UUID()
    let city: String
    let code: String
    let country: String
    let imageURL: String
    let startingPrice: Int
    let isInternational: Bool
    
    init(city: String, code: String, country: String, imageURL: String = "", startingPrice: Int, isInternational: Bool = false) {
        self.city = city
        self.code = code
        self.country = country
        self.imageURL = imageURL
        self.startingPrice = startingPrice
        self.isInternational = isInternational
    }
}

struct RecentSearch: Identifiable, Codable {
    let id = UUID()
    let from: String
    let to: String
    let fromCode: String
    let toCode: String
    let date: Date
    let passengers: Int
    let searchDate: Date
    
    init(from: String, to: String, fromCode: String, toCode: String, date: Date, passengers: Int) {
        self.from = from
        self.to = to
        self.fromCode = fromCode
        self.toCode = toCode
        self.date = date
        self.passengers = passengers
        self.searchDate = Date()
    }
}

struct FlightRoute: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let fromCode: String
    let toCode: String
    let flights: [Flight]
    let avgPrice: Int
    let duration: String
}

// MARK: - Enhanced HomeViewModel

class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    // Published properties
    @Published var flights = [Flight]()
    @Published var popularDestinations = [PopularDestination]()
    @Published var recentSearches = [RecentSearch]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var flightRoutes = [FlightRoute]()
    
    // Search functionality
    @Published var searchQuery = ""
    @Published var filteredFlights = [Flight]()
    
    init() {
        loadPopularDestinations()
        loadRecentSearches()
        loadFlights()
        setupSearchSubscriber()
    }
    
    // MARK: - Data Loading Methods
    
    func loadFlights() {
        flights = generateComprehensiveFlightData()
        organizeFlightsByRoutes()
    }
    
    func loadPopularDestinations() {
        popularDestinations = [
            // Domestic Popular Destinations
            PopularDestination(city: "Mumbai", code: "BOM", country: "India",imageURL: "dest1", startingPrice: 3500),
            PopularDestination(city: "Delhi", code: "DEL", country: "India", imageURL: "dest2",startingPrice: 4000),
            PopularDestination(city: "Bangalore", code: "BLR", country: "India",imageURL: "dest3", startingPrice: 4200),
            PopularDestination(city: "Chennai", code: "MAA", country: "India", imageURL: "dest4",startingPrice: 4600),
            PopularDestination(city: "Kolkata", code: "CCU", country: "India",imageURL: "dest5", startingPrice: 5200),
            PopularDestination(city: "Goa", code: "GOI", country: "India",imageURL: "dest6", startingPrice: 4200),
            
            // International Popular Destinations
            PopularDestination(city: "Dubai", code: "DXB", country: "UAE",imageURL: "dest7", startingPrice: 16200, isInternational: true),
            PopularDestination(city: "Singapore", code: "SIN", country: "Singapore", imageURL: "dest8",startingPrice: 22500, isInternational: true),
            PopularDestination(city: "London", code: "LHR", country: "UK",imageURL: "dest9", startingPrice: 42000, isInternational: true),
            PopularDestination(city: "Bangkok", code: "BKK", country: "Thailand", imageURL: "dest10",startingPrice: 19500, isInternational: true),
            PopularDestination(city: "New York", code: "JFK", country: "USA", imageURL: "dest11",startingPrice: 52000, isInternational: true),
            PopularDestination(city: "Sydney", code: "SYD", country: "Australia", imageURL: "dest12",startingPrice: 58000, isInternational: true)
        ]
    }
    
    func loadRecentSearches() {
        // Load from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "RecentSearches"),
           let searches = try? JSONDecoder().decode([RecentSearch].self, from: data) {
            recentSearches = searches.sorted { $0.searchDate > $1.searchDate }
        }
    }
    
    func saveRecentSearches() {
        if let data = try? JSONEncoder().encode(recentSearches) {
            UserDefaults.standard.set(data, forKey: "RecentSearches")
        }
    }
    
    // MARK: - Search Functionality
    
    private func setupSearchSubscriber() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.filterFlights(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func filterFlights(query: String) {
        if query.isEmpty {
            filteredFlights = flights
        } else {
            filteredFlights = flights.filter { flight in
                flight.source?.localizedCaseInsensitiveContains(query) == true ||
                flight.destination?.localizedCaseInsensitiveContains(query) == true ||
                flight.sourceCode?.localizedCaseInsensitiveContains(query) == true ||
                flight.destinationCode?.localizedCaseInsensitiveContains(query) == true ||
                flight.company?.localizedCaseInsensitiveContains(query) == true
            }
        }
    }
    
    // MARK: - Recent Search Management
    
    func addRecentSearch(from: String, to: String, fromCode: String, toCode: String, date: Date, passengers: Int) {
        let newSearch = RecentSearch(
            from: from,
            to: to,
            fromCode: fromCode,
            toCode: toCode,
            date: date,
            passengers: passengers
        )
        
        // Remove duplicate if exists
        recentSearches.removeAll { existing in
            existing.fromCode == newSearch.fromCode &&
            existing.toCode == newSearch.toCode &&
            Calendar.current.isDate(existing.date, inSameDayAs: newSearch.date)
        }
        
        // Add new search at beginning
        recentSearches.insert(newSearch, at: 0)
        
        // Keep only last 10 searches
        if recentSearches.count > 10 {
            recentSearches = Array(recentSearches.prefix(10))
        }
        
        saveRecentSearches()
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
        saveRecentSearches()
    }
    
    // MARK: - Flight Organization
    
    private func organizeFlightsByRoutes() {
        let groupedFlights = Dictionary(grouping: flights) { flight in
            "\(flight.sourceCode ?? "")-\(flight.destinationCode ?? "")"
        }
        
        flightRoutes = groupedFlights.compactMap { (key, flights) in
            guard let firstFlight = flights.first else { return nil }
            
            let avgPrice = flights.map { $0.fare }.reduce(0, +) / flights.count
            
            return FlightRoute(
                from: firstFlight.source ?? "",
                to: firstFlight.destination ?? "",
                fromCode: firstFlight.sourceCode ?? "",
                toCode: firstFlight.destinationCode ?? "",
                flights: flights.sorted { $0.fare < $1.fare },
                avgPrice: avgPrice,
                duration: firstFlight.duration ?? ""
            )
        }
        .sorted { $0.from < $1.from }
    }
    
    // MARK: - Flight Search Methods
    
    func searchFlights(from: String, to: String, date: Date = Date(), passengers: Int = 1) -> [Flight] {
        // Add to recent searches
        addRecentSearch(
            from: from,
            to: to,
            fromCode: from.prefix(3).uppercased(),
            toCode: to.prefix(3).uppercased(),
            date: date,
            passengers: passengers
        )
        
        // Filter flights based on route
        let fromCode = from.prefix(3).uppercased()
        let toCode = to.prefix(3).uppercased()
        
        let matchingFlights = flights.filter { flight in
            flight.sourceCode?.uppercased() == fromCode &&
            flight.destinationCode?.uppercased() == toCode
        }
        
        return matchingFlights.sorted { $0.fare < $1.fare }
    }
    
    func getFlightsByRoute(fromCode: String, toCode: String) -> [Flight] {
        return flights.filter { flight in
            flight.sourceCode == fromCode && flight.destinationCode == toCode
        }.sorted { $0.fare < $1.fare }
    }
    
    func getCheapestFlightForRoute(fromCode: String, toCode: String) -> Flight? {
        return getFlightsByRoute(fromCode: fromCode, toCode: toCode).first
    }
    
    // MARK: - Network Methods
    
    func getHomeData() {
        isLoading = true
        errorMessage = nil
        
        // Simulate network call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            // In a real app, you would make the actual network call here
            // NetworkManager.shared.getData(endpoint: .flights, type: Flight.self)...
        }
    }
    
    func refreshData() {
        loadFlights()
        loadPopularDestinations()
        organizeFlightsByRoutes()
    }
    
    // MARK: - Optimized Flight Data Generation
    
    private func generateComprehensiveFlightData() -> [Flight] {
        let routes = [
            // Major Domestic Routes
            ("Mumbai", "BOM", "Delhi", "DEL", ["6E-2024": ("IndiGo", 4500), "AI-401": ("Air India", 5200), "SG-8123": ("SpiceJet", 3800), "UK-851": ("Vistara", 6200)]),
            ("Delhi", "DEL", "Mumbai", "BOM", ["6E-2025": ("IndiGo", 4300), "AI-402": ("Air India", 5000), "SG-8124": ("SpiceJet", 3600), "UK-852": ("Vistara", 6000)]),
            ("Mumbai", "BOM", "Bangalore", "BLR", ["G8-2134": ("GoAir", 4200), "UK-545": ("Vistara", 4800), "6E-5001": ("IndiGo", 4500)]),
            ("Delhi", "DEL", "Bangalore", "BLR", ["6E-5234": ("IndiGo", 5500), "AI-507": ("Air India", 6200), "SG-8234": ("SpiceJet", 5000)]),
            ("Chennai", "MAA", "Delhi", "DEL", ["6E-7891": ("IndiGo", 5800), "AI-543": ("Air India", 6200)]),
            ("Mumbai", "BOM", "Goa", "GOI", ["SG-1234": ("SpiceJet", 4200), "6E-6789": ("IndiGo", 4500)]),
            
            // International Routes
            ("Mumbai", "BOM", "Dubai", "DXB", ["EK-504": ("Emirates", 18500), "AI-131": ("Air India", 16200)]),
            ("Delhi", "DEL", "Dubai", "DXB", ["EK-512": ("Emirates", 19200), "AI-985": ("Air India", 17500)]),
            ("Mumbai", "BOM", "Singapore", "SIN", ["SQ-401": ("Singapore Airlines", 28500), "6E-1008": ("IndiGo", 25000)]),
            ("Delhi", "DEL", "London", "LHR", ["BA-142": ("British Airways", 45500), "AI-131": ("Air India", 42000)]),
            ("Mumbai", "BOM", "New York", "JFK", ["AI-119": ("Air India", 65000), "UA-82": ("United Airlines", 68000)]),
            ("Delhi", "DEL", "Bangkok", "BKK", ["TG-315": ("Thai Airways", 22500), "AI-333": ("Air India", 20000)])
        ]
        
        var generatedFlights: [Flight] = []
        var flightId = 1001
        
        for (source, sourceCode, destination, destCode, flightData) in routes {
            for (flightNumber, (company, baseFare)) in flightData {
                // Generate multiple time slots for each route
                let timeSlots = [
                    ("06:30", "08:45", "2h 15m"),
                    ("09:15", "11:30", "2h 15m"),
                    ("14:20", "16:35", "2h 15m"),
                    ("18:45", "21:00", "2h 15m")
                ]
                
                for (index, (departure, arrival, duration)) in timeSlots.enumerated() {
                    let fareVariation = Int.random(in: -500...1000)
                    let adjustedFare = max(baseFare + fareVariation, baseFare / 2)
                    
                    let flight = Flight(
                        id: flightId,
                        flightNumber: "\(flightNumber.prefix(2))-\(String(format: "%04d", (Int(flightNumber.suffix(4)) ?? 22) + index))",
                        company: company,
                        source: source,
                        sourceCode: sourceCode,
                        sourceAirport: getAirportName(for: sourceCode),
                        destination: destination,
                        destinationCode: destCode,
                        destinationAirport: getAirportName(for: destCode),
                        departure: departure,
                        arrival: arrival,
                        duration: duration,
                        fare: adjustedFare,
                        checkin: getCheckinAllowance(for: company),
                        cabin: "7 kg",
                        cancellation: getCancellationPolicy(for: company)
                    )
                    
                    generatedFlights.append(flight)
                    flightId += 1
                }
            }
        }
        
        return generatedFlights
    }
    
    // MARK: - Helper Methods
    
    private func getAirportName(for code: String) -> String {
        let airports = [
            "BOM": "Chhatrapati Shivaji Maharaj International Airport",
            "DEL": "Indira Gandhi International Airport",
            "BLR": "Kempegowda International Airport",
            "MAA": "Chennai International Airport",
            "CCU": "Netaji Subhas Chandra Bose International Airport",
            "GOI": "Dabolim Airport",
            "DXB": "Dubai International Airport",
            "SIN": "Changi Airport",
            "LHR": "Heathrow Airport",
            "JFK": "John F. Kennedy International Airport",
            "BKK": "Suvarnabhumi Airport",
            "DOH": "Hamad International Airport"
        ]
        return airports[code] ?? "\(code) Airport"
    }
    
    private func getCheckinAllowance(for airline: String) -> String {
        let allowances = [
            "IndiGo": "15 kg",
            "Air India": "20 kg",
            "SpiceJet": "15 kg",
            "Vistara": "15 kg",
            "GoAir": "15 kg",
            "Emirates": "30 kg",
            "Singapore Airlines": "30 kg",
            "British Airways": "23 kg",
            "United Airlines": "23 kg",
            "Thai Airways": "30 kg"
        ]
        return allowances[airline] ?? "15 kg"
    }
    
    private func getCancellationPolicy(for airline: String) -> String {
        let policies = [
            "IndiGo": "Free cancellation up to 24 hours before departure",
            "Air India": "Free cancellation up to 24 hours before departure",
            "SpiceJet": "Cancellation charges apply",
            "Vistara": "Free cancellation up to 24 hours before departure",
            "GoAir": "Cancellation charges apply",
            "Emirates": "Free cancellation up to 24 hours before departure",
            "Singapore Airlines": "Free cancellation up to 24 hours before departure",
            "British Airways": "Free cancellation up to 24 hours before departure",
            "United Airlines": "Cancellation charges apply as per airline policy",
            "Thai Airways": "Free cancellation up to 24 hours before departure"
        ]
        return policies[airline] ?? "Cancellation charges apply"
    }
    
    // MARK: - Analytics Methods
    
    func getPopularRoutes() -> [(from: String, to: String, count: Int)] {
        let routeCounts = Dictionary(grouping: recentSearches) { search in
            "\(search.fromCode)-\(search.toCode)"
        }.mapValues { $0.count }
        
        return routeCounts
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { (key, count) in
                let codes = key.split(separator: "-")
                let fromCode = String(codes[0])
                let toCode = String(codes[1])
                
                let fromCity = popularDestinations.first { $0.code == fromCode }?.city ?? fromCode
                let toCity = popularDestinations.first { $0.code == toCode }?.city ?? toCode
                
                return (from: fromCity, to: toCity, count: count)
            }
    }
    
    func getPriceRange(for route: String) -> (min: Int, max: Int)? {
        let routeFlights = flights.filter { flight in
            "\(flight.sourceCode ?? "")-\(flight.destinationCode ?? "")" == route
        }
        
        guard !routeFlights.isEmpty else { return nil }
        
        let prices = routeFlights.map { $0.fare }
        return (min: prices.min() ?? 0, max: prices.max() ?? 0)
    }
}
