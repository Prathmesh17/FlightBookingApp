//
//  FlightDetailView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct FlightDetailView: View {
    let flight: Flight
    let passengers: Int
    @EnvironmentObject var bookingManager: BookingManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showTerms = false
    @State private var showSeatMap = false
    @State private var showingPassengerDetails = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Sky Blue Fade Gradient background
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

                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection
                        
                        // Debug info (remove this later)
                        Text("Flight: \(flight.flightNumber ?? "N/A") - \(flight.company ?? "N/A")")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        // Main Flight Details Card
                        mainFlightCard
                        
                        // Flight Amenities Section
                        amenitiesSection
                        
                        // Aircraft Information
                        aircraftInfoSection
                        
                        // Additional Options
                        additionalOptionsSection
                        
                        // Terms and Important Info
                        termsInfoSection
                        
                        Spacer(minLength: 20)
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showingPassengerDetails) {
            PassengerDetailsView(passengerCount: passengers)
                .environmentObject(bookingManager)
        }
        .onAppear {
            print("FlightDetailView appeared with flight: \(flight.flightNumber ?? "Unknown")")
            // Set the selected flight in booking manager
            bookingManager.bookingDetails.outboundFlight = flight
        }
        .sheet(isPresented: $showTerms) {
            TermsAndConditionsView()
        }
        .sheet(isPresented: $showSeatMap) {
            SeatMapView()
        }
    }
    
    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
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
            
            Text("Flight Details")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Spacer()
            
            // Placeholder for balance
            Color.clear
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Main Flight Card
    @ViewBuilder
    private var mainFlightCard: some View {
        VStack(spacing: 20) {
            // Flight Number and Company
            HStack {
                Text(flight.company ?? "Air India")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("-")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Text(flight.flightNumber ?? "AI 101")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            // Source and Destination
            HStack {
                VStack(spacing: 8) {
                    Text(flight.sourceCode ?? "DEL")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(flight.source ?? "Delhi")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "airplane")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 28)
                        .foregroundColor(.blue)
                    
                    Text(flight.duration ?? "2h 15m")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text(flight.destinationCode ?? "BOM")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(flight.destination ?? "Mumbai")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            
            // Airport Details
            HStack {
                Text(flight.sourceAirport ?? "Indira Gandhi International")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text(flight.destinationAirport ?? "Chhatrapati Shivaji International")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
            }

            // Departure - Duration - Arrival
            HStack {
                VStack(spacing: 6) {
                    Image(systemName: "airplane.departure")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text(flight.departure ?? "06:30")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Departure")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(spacing: 6) {
                    Text("Non-stop")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                        .frame(width: 80, height: 2)
                        .foregroundColor(.blue.opacity(0.5))
                }
                
                Spacer()
                
                VStack(spacing: 6) {
                    Image(systemName: "airplane.arrival")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text(flight.arrival ?? "08:45")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Arrival")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            // Baggage Info
            VStack(alignment: .leading, spacing: 12) {
                Text("Baggage Allowance")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Check-in")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack(spacing: 6) {
                            Image(systemName: "suitcase.cart.fill")
                                .foregroundColor(.blue)
                            Text(flight.checkin ?? "15 kg")
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("Cabin")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack(spacing: 6) {
                            Text(flight.cabin ?? "7 kg")
                                .fontWeight(.medium)
                            Image(systemName: "suitcase.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }

            Divider()
                .background(Color.blue.opacity(0.3))

            // Fare and Book Button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("₹ \(flight.fare)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("per person • \(passengers) passenger\(passengers > 1 ? "s" : "")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    showingPassengerDetails = true
                }) {
                    HStack(spacing: 8) {
                        Text("Add Passengers")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)
        .frame(maxWidth: 360)
    }
    
    // MARK: - Amenities Section
    @ViewBuilder
    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Flight Amenities")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 20) {
                AmenityItem(icon: "wifi", text: "WiFi", available: true)
                AmenityItem(icon: "fork.knife", text: "Meals", available: true)
                AmenityItem(icon: "tv", text: "Entertainment", available: false)
                AmenityItem(icon: "powerplug", text: "Power", available: true)
            }
        }
        .padding()
        .background(Color.white.opacity(0.95))
        .cornerRadius(16)
        .frame(maxWidth: 360)
    }
    
    // MARK: - Aircraft Info Section
    @ViewBuilder
    private var aircraftInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Aircraft Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Aircraft Type")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Boeing 737-800")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Total Seats")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("180 seats")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            
            Button("View Seat Map") {
                showSeatMap = true
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            .padding(.top, 4)
        }
        .padding()
        .background(Color.white.opacity(0.95))
        .cornerRadius(16)
        .frame(maxWidth: 360)
    }
    
    // MARK: - Additional Options Section
    @ViewBuilder
    private var additionalOptionsSection: some View {
        VStack(spacing: 16) {
            Text("Add-on Services")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                AddonServiceRow(
                    icon: "shield.checkered",
                    iconColor: .green,
                    title: "Travel Insurance",
                    price: "₹ 99"
                )
                
                AddonServiceRow(
                    icon: "car.fill",
                    iconColor: .blue,
                    title: "Airport Transfer",
                    price: "₹ 299"
                )
                
                AddonServiceRow(
                    icon: "bed.double.fill",
                    iconColor: .purple,
                    title: "Extra Legroom",
                    price: "₹ 499"
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.95))
        .cornerRadius(16)
        .frame(maxWidth: 360)
    }
    
    // MARK: - Terms Info Section
    @ViewBuilder
    private var termsInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button("Terms & Conditions") {
                showTerms = true
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 8) {
                ImportantInformationRow(text: "Free cancellation up to 24 hours before departure")
                ImportantInformationRow(text: "Arrive at airport 2 hours before domestic flights")
                ImportantInformationRow(text: "Valid government ID required for boarding")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .frame(maxWidth: 360)
    }
}

// MARK: - Supporting Components

struct AmenityItem: View {
    let icon: String
    let text: String
    let available: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(available ? .green : .gray)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(available ? .black : .gray)
        }
        .opacity(available ? 1.0 : 0.6)
        .frame(maxWidth: .infinity)
    }
}

struct AddonServiceRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let price: String
    @State private var isSelected = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(price)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            Toggle("", isOn: $isSelected)
                .scaleEffect(0.8)
        }
        .padding(.vertical, 4)
    }
}

struct ImportantInformationRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.top, 2)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

// MARK: - Modal Views

// Terms and Conditions View
struct TermsAndConditionsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms & Conditions")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Booking Terms")
                        .font(.headline)
                        .padding(.top)
                    
                    Text("• Tickets are non-transferable\n• Name changes not allowed\n• Refunds subject to airline policy\n• Prices include all taxes and fees")
                        .font(.body)
                    
                    Text("Cancellation Policy")
                        .font(.headline)
                        .padding(.top)
                    
                    Text("• Free cancellation up to 24 hours before departure\n• Cancellation charges apply after 24 hours\n• No-show passengers forfeit entire ticket value")
                        .font(.body)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Seat Map View
struct SeatMapView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Seat Map")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Boeing 737-800")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(1...30, id: \.self) { row in
                            HStack(spacing: 12) {
                                HStack(spacing: 4) {
                                    SeatView(seatNumber: "\(row)A", isAvailable: true)
                                    SeatView(seatNumber: "\(row)B", isAvailable: row % 3 != 0)
                                    SeatView(seatNumber: "\(row)C", isAvailable: true)
                                }
                                
                                Text("\(row)")
                                    .font(.caption)
                                    .frame(width: 20)
                                
                                HStack(spacing: 4) {
                                    SeatView(seatNumber: "\(row)D", isAvailable: row % 4 != 0)
                                    SeatView(seatNumber: "\(row)E", isAvailable: true)
                                    SeatView(seatNumber: "\(row)F", isAvailable: row % 5 != 0)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SeatView: View {
    let seatNumber: String
    let isAvailable: Bool
    
    var body: some View {
        Rectangle()
            .fill(isAvailable ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
            .frame(width: 25, height: 25)
            .cornerRadius(4)
            .overlay(
                Text(seatNumber.suffix(1))
                    .font(.caption2)
                    .fontWeight(.medium)
            )
    }
}
