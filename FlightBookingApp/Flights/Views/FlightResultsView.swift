//
//  FlightResultsView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct FlightResultsView: View {
    let flights: [Flight]
    @EnvironmentObject var bookingManager: BookingManager
    @Environment(\.presentationMode) var presentationMode
    
    let fromCity: String
    let toCity: String
    let departureDate: Date
    let passengers: Int
    
    @State private var selectedFlight: Flight?
    @State private var showingFlightDetail = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color("BG")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        headerSection
                        
                        // Flights List
                        flightsListSection
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingFlightDetail) {
            if let flight = selectedFlight {
                FlightDetailView(flight: flight, passengers: passengers)
                    .environmentObject(bookingManager)
            } else {
                // Fallback view if flight is nil
                Text("Flight details not available")
                    .font(.title2)
                    .padding()
            }
        }
        .onChange(of: selectedFlight) { flight in
            if flight != nil {
                showingFlightDetail = true
            }
        }
    }
    
    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Main Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(fromCity) → \(toCity)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption)
                            Text(departureDate, style: .date)
                        }
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.caption)
                            Text("\(passengers) passenger\(passengers > 1 ? "s" : "")")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            
            // Results Count
            if !flights.isEmpty {
                HStack {
                    Text("\(flights.count) flight\(flights.count > 1 ? "s" : "") found")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.caption)
                        Text("Sort by Price")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Flights List Section
    @ViewBuilder
    private var flightsListSection: some View {
        if flights.isEmpty {
            // Empty State
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "airplane.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.gray.opacity(0.5))
                
                VStack(spacing: 8) {
                    Text("No flights found")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Try adjusting your search criteria")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Button("Modify Search") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(25)
                .fontWeight(.semibold)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        } else {
            // Flights List
            LazyVStack(spacing: 16) {
                ForEach(flights, id: \.id) { flight in
                    FlightCardView(
                        flight: flight,
                        onBookTapped: {
                            print("Book tapped for flight: \(flight.flightNumber ?? "Unknown")")
                            selectedFlight = flight
                            bookingManager.selectFlight(flight)
                        }
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Flight Card View
struct FlightCardView: View {
    let flight: Flight
    let onBookTapped: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    // Sky Blue Fade Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color(red: 0.87, green: 0.94, blue: 1.0),
                            Color(red: 0.76, green: 0.89, blue: 0.99)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(
                    color: Color.blue.opacity(0.15),
                    radius: isPressed ? 8 : 12,
                    x: 0,
                    y: isPressed ? 4 : 8
                )
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
            
            VStack(spacing: 18) {
                // Header: Flight Number & Airline
                HStack {
                    Label(flight.flightNumber ?? "AI 101", systemImage: "airplane")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(flight.company ?? "Air India")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                
                // Main Route Section
                HStack {
                    // Departure
                    VStack(spacing: 6) {
                        Text(flight.sourceCode ?? "DEL")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        Text(flight.source ?? "Delhi")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.black.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    // Flight Path with Duration
                    VStack(spacing: 8) {
                        Image(systemName: "airplane")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 24)
                            .foregroundColor(.blue.opacity(0.8))
                            .rotationEffect(.degrees(0))
                        
                        Text(flight.duration ?? "2h 15m")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    // Arrival
                    VStack(spacing: 6) {
                        Text(flight.destinationCode ?? "BOM")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        Text(flight.destination ?? "Mumbai")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.black.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Timing Section
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "airplane.departure")
                            .foregroundColor(.blue.opacity(0.7))
                        Text(flight.departure ?? "06:30")
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    // Non-stop indicator
                    Text("Non-stop")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "airplane.arrival")
                            .foregroundColor(.blue.opacity(0.7))
                        Text(flight.arrival ?? "08:45")
                            .fontWeight(.medium)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.black)
                
                // Dashed Line
                Line()
                    .stroke(
                        style: StrokeStyle(lineWidth: 1, dash: [6, 4])
                    )
                    .frame(height: 1)
                    .foregroundColor(.blue.opacity(0.4))
                    .padding(.vertical, 2)
                
                // Price & Book Section
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("₹ \(flight.fare)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text("per person")
                            .font(.caption)
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("Button tapped for flight: \(flight.id)")
                        onBookTapped()
                    }) {
                        HStack(spacing: 6) {
                            Text("Book Now")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue,
                                    Color.blue.opacity(0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(
                            color: Color.blue.opacity(0.3),
                            radius: 6,
                            x: 0,
                            y: 3
                        )
                    }
                }
            }
            .padding(20)
        }
        .frame(maxWidth: 360, minHeight: 260, maxHeight: 260)
        .pressEvents(
            onPress: { isPressed = true },
            onRelease: { isPressed = false }
        )
    }
}

// MARK: - Supporting Views and Extensions

// Your dashed line
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

// Custom modifier for press events
struct PressEvents: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEvents(onPress: onPress, onRelease: onRelease))
    }
}

// Utility for converting hex to Color (keeping your original)
extension Color {
    init(hex: String) {
        let uiColor = hexStringToUIColor(hex: hex)
        self.init(uiColor)
    }
}

