//
//  ProfileView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var bookingManager: BookingManager
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var showingNotifications = false
    @State private var showingTravelPreferences = false
    @State private var showingHelp = false
    @State private var showingAbout = false
    @State private var isLoggedIn = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    headerSection
                    
                    // Main Content
                    VStack(spacing: 24) {
                        // User Stats Section
                        userStatsSection
                        
                        // Quick Actions Section
                        quickActionsSection
                        
                        // Account Section
                        accountSection
                        
                        // Travel Section
                        travelSection
                        
                        // App Section
                        appSection
                        
                        // Support Section
                        supportSection
                        
                        // Logout Section
                        logoutSection
                    }
                    .padding()
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 0.95, green: 0.98, blue: 1.0),
                        Color(red: 0.87, green: 0.94, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingNotifications) {
            NotificationSettingsView()
        }
        .sheet(isPresented: $showingTravelPreferences) {
            TravelPreferencesView()
        }
        .sheet(isPresented: $showingHelp) {
            HelpSupportView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
    
    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Profile Picture and Info
            VStack(spacing: 16) {
                ZStack {
                    // Profile Background Circle
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.2),
                                    Color.purple.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    // Profile Image
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 90, height: 90)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                        )
                    
                    // Edit Button
                    Button(action: { showingEditProfile = true }) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "pencil")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    }
                    .offset(x: 35, y: 35)
                }
                
                // User Info
                VStack(spacing: 8) {
                    Text("John Doe")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("john.doe@example.com")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Membership Badge
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("Gold Member")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .foregroundColor(.orange)
                    .cornerRadius(12)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.bottom, 30)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.clear
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: - User Stats Section
    @ViewBuilder
    private var userStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Travel Stats")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 16) {
                StatProofCard(
                    icon: "airplane.departure",
                    title: "Flights Booked",
                    value: "12",
                    color: .blue
                )
                
                StatProofCard(
                    icon: "globe.asia.australia",
                    title: "Countries Visited",
                    value: "8",
                    color: .green
                )
                
                StatProofCard(
                    icon: "star.fill",
                    title: "Points Earned",
                    value: "2,450",
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Quick Actions Section
    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                QuickActionCard(
                    icon: "airplane.circle.fill",
                    title: "My Bookings",
                    subtitle: "View all trips",
                    color: .blue
                ) {
                    // Navigate to bookings
                }
                
                QuickActionCard(
                    icon: "heart.circle.fill",
                    title: "Wishlist",
                    subtitle: "Saved destinations",
                    color: .red
                ) {
                    // Navigate to wishlist
                }
                
                QuickActionCard(
                    icon: "creditcard.circle.fill",
                    title: "Payment Methods",
                    subtitle: "Manage cards",
                    color: .green
                ) {
                    // Navigate to payment methods
                }
                
                QuickActionCard(
                    icon: "doc.circle.fill",
                    title: "Travel Documents",
                    subtitle: "Passport, visa info",
                    color: .purple
                ) {
                    // Navigate to documents
                }
            }
        }
    }
    
    // MARK: - Account Section
    @ViewBuilder
    private var accountSection: some View {
        ProfileSection(title: "Account") {
            VStack(spacing: 0) {
                ProfileRow(
                    icon: "person.circle",
                    title: "Edit Profile",
                    subtitle: "Update personal information",
                    color: .blue
                ) {
                    showingEditProfile = true
                }
                
                ProfileRow(
                    icon: "bell.circle",
                    title: "Notifications",
                    subtitle: "Manage your alerts",
                    color: .orange
                ) {
                    showingNotifications = true
                }
                
                ProfileRow(
                    icon: "lock.circle",
                    title: "Privacy & Security",
                    subtitle: "Password, two-factor auth",
                    color: .red
                ) {
                    showingSettings = true
                }
                
                ProfileRow(
                    icon: "creditcard.circle",
                    title: "Payment & Billing",
                    subtitle: "Cards, receipts, refunds",
                    color: .green
                ) {
                    // Navigate to payment settings
                }
            }
        }
    }
    
    // MARK: - Travel Section
    @ViewBuilder
    private var travelSection: some View {
        ProfileSection(title: "Travel") {
            VStack(spacing: 0) {
                ProfileRow(
                    icon: "airplane.circle",
                    title: "Travel Preferences",
                    subtitle: "Seat, meal, class preferences",
                    color: .blue
                ) {
                    showingTravelPreferences = true
                }
                
                ProfileRow(
                    icon: "mappin.circle",
                    title: "Saved Addresses",
                    subtitle: "Home, work, frequent locations",
                    color: .purple
                ) {
                    // Navigate to saved addresses
                }
                
                ProfileRow(
                    icon: "person.2.circle",
                    title: "Travel Companions",
                    subtitle: "Frequent co-travelers",
                    color: .indigo
                ) {
                    // Navigate to travel companions
                }
                
                ProfileRow(
                    icon: "doc.text.circle",
                    title: "Travel Documents",
                    subtitle: "Passport, visa information",
                    color: .brown
                ) {
                    // Navigate to documents
                }
            }
        }
    }
    
    // MARK: - App Section
    @ViewBuilder
    private var appSection: some View {
        ProfileSection(title: "App") {
            VStack(spacing: 0) {
                ProfileRow(
                    icon: "gearshape.circle",
                    title: "Settings",
                    subtitle: "App preferences, language",
                    color: .gray
                ) {
                    showingSettings = true
                }
                
                ProfileRow(
                    icon: "square.and.arrow.up.circle",
                    title: "Share App",
                    subtitle: "Tell friends about this app",
                    color: .blue
                ) {
                    shareApp()
                }
                
                ProfileRow(
                    icon: "star.circle",
                    title: "Rate App",
                    subtitle: "Rate us on the App Store",
                    color: .orange
                ) {
                    rateApp()
                }
            }
        }
    }
    
    // MARK: - Support Section
    @ViewBuilder
    private var supportSection: some View {
        ProfileSection(title: "Support") {
            VStack(spacing: 0) {
                ProfileRow(
                    icon: "questionmark.circle",
                    title: "Help & Support",
                    subtitle: "FAQs, contact support",
                    color: .blue
                ) {
                    showingHelp = true
                }
                
                ProfileRow(
                    icon: "info.circle",
                    title: "About",
                    subtitle: "App version, terms, privacy",
                    color: .indigo
                ) {
                    showingAbout = true
                }
                
                ProfileRow(
                    icon: "exclamationmark.circle",
                    title: "Report an Issue",
                    subtitle: "Bug reports, feedback",
                    color: .red
                ) {
                    reportIssue()
                }
            }
        }
    }
    
    // MARK: - Logout Section
    @ViewBuilder
    private var logoutSection: some View {
        Button(action: logout) {
            HStack {
                Image(systemName: "arrow.right.square")
                    .font(.title3)
                    .foregroundColor(.red)
                
                Text("Sign Out")
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.top, 8)
    }
    
    // MARK: - Helper Methods
    
    private func shareApp() {
        // Implement app sharing
    }
    
    private func rateApp() {
        // Open App Store rating
    }
    
    private func reportIssue() {
        // Open issue reporting
    }
    
    private func logout() {
        // Implement logout functionality
        isLoggedIn = false
    }
}

// MARK: - Supporting Components

struct StatProofCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct QuickActionCard: View {
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

struct ProfileSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Modal Views (Placeholder implementations)

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Profile")
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Notification Settings")
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Notifications")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct TravelPreferencesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Travel Preferences")
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Travel Preferences")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct HelpSupportView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Help & Support")
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Help & Support")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "airplane.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Flight Booking App")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Version 1.0.0")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("About")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    ProfileView()
}
