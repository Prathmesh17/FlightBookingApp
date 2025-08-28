//
//  MyTripsDetailView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct MyTripsDetailView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                if bookingManager.getBookingHistory().isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "airplane.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No trips yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Your booked flights will appear here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Show booking history
                    List {
                        ForEach(bookingManager.getBookingHistory(), id: \.self) { bookingRef in
                            HStack {
                                Image(systemName: "airplane.departure")
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text("Booking \(bookingRef)")
                                        .fontWeight(.medium)
                                    Text("Confirmed")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("My Trips")
            .navigationBarItems(trailing: Button("Done"){
                presentationMode.wrappedValue.dismiss()
            }
                .foregroundColor(.blue))
                                
        }
    }
}


