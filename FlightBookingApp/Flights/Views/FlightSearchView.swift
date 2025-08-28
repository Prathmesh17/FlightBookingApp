//
//  FlightSearchView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct FlightSearchView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @ObservedObject var viewModel = HomeViewModel()
    @State private var fromCity = "Mumbai"
    @State private var toCity = "Delhi"
    @State private var departureDate = Date()
    @State private var returnDate = Date().addingTimeInterval(7 * 24 * 60 * 60)
    @State private var passengers = 1
    @State private var tripType = 0 // 0: Round trip, 1: One way
    @State private var showingResults = false
    
    let cities = ["Mumbai", "Delhi", "Banglore", "Chennai", "Kolkata", "Dubai", "London", "New York","Goa"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Book Your Flight")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Find the best deals for your next adventure")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Trip Type Selector
                Picker("Trip Type", selection: $tripType) {
                    Text("Round Trip").tag(0)
                    Text("One Way").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Flight Route Card
                VStack(spacing: 16) {
                    // From/To Cities
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("From")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Menu {
                                ForEach(cities, id: \.self) { city in
                                    Button(city) {
                                        fromCity = city
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(fromCity)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                        
                        Button(action: swapCities) {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("To")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Menu {
                                ForEach(cities, id: \.self) { city in
                                    Button(city) {
                                        toCity = city
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(toCity)
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                    Divider()
                    
                    // Date Selection
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Departure")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            DatePicker("", selection: $departureDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                        
                        if tripType == 0 {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Return")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                DatePicker("", selection: $returnDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Passengers
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Passengers")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("\(passengers) Adult\(passengers > 1 ? "s" : "")")
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Stepper("", value: $passengers, in: 1...9)
                            .labelsHidden()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Search Button
                Button(action: searchFlights) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search Flights")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingResults) {
            FlightResultsView(
                flights: viewModel.flights,
                fromCity: fromCity,
                toCity: toCity,
                departureDate: departureDate,
                passengers: passengers
            )
            .environmentObject(bookingManager)
        }
    }
    
    private func swapCities() {
        let temp = fromCity
        fromCity = toCity
        toCity = temp
    }
    
    private func searchFlights() {
        showingResults = true
    }
}
