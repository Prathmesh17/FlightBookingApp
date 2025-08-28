//
//  ContentView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @StateObject var bookingManager = BookingManager()
    @State private var showingProfile = false
    @State private var showingNotifications = false
    @State private var selectedTab = 0
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            homeView
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            
            // My Trips Tab
            myTripsView
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "airplane.circle.fill" : "airplane.circle")
                    Text("My Trips")
                }
                .tag(1)
            
            // Profile Tab
            profileView
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.circle.fill" : "person.circle")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .onAppear {
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().showsVerticalScrollIndicator = false
            viewModel.getHomeData()
        }
    }
    
    // MARK: - Home View
    @ViewBuilder
    private var homeView: some View {
        NavigationView {
            ZStack {
                // Sky Blue Fade Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white,
                        Color(red: 0.95, green: 0.98, blue: 1.0),
                        Color(red: 0.87, green: 0.94, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        headerSection
                        
                        // Quick Search Section
                        quickSearchSection
                        
                        // Popular Destinations
                        popularDestinationsSection
                        
                        // Travel Deals
                        travelDealsSection
                        
                        // Quick Stats
                        quickStatsSection
                        
                        // Recent Searches
                        recentSearchesSection
                        
                        // Footer Space
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
        }
        .environmentObject(bookingManager)
    }
    
    // MARK: - Header Section
    @ViewBuilder
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Top Bar
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, Traveler! ✈️")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text("Where would you like to go?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: { showingNotifications = true }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "bell")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Button(action: { showingProfile = true }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "person")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
    }
    
    // MARK: - Quick Search Section
    @ViewBuilder
    private var quickSearchSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            FlightSearchView()
                .environmentObject(bookingManager)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Popular Destinations
    @ViewBuilder
    private var popularDestinationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Popular Destinations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    selectedTab = 1
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.popularDestinations, id: \.code) { destination in
                        PopularDestinationCard(destination: destination)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    // MARK: - Travel Deals Section
    @ViewBuilder
    private var travelDealsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Special Offers")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("Limited Time")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(8)
            }
            
            HorizontalImageScrollView()
        }
    }
    
    // MARK: - Quick Stats Section
    @ViewBuilder
    private var quickStatsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                icon: "airplane.departure",
                title: "Flights Today",
                value: "\(viewModel.flights.count)",
                color: .blue
            )
            
            StatCard(
                icon: "globe.asia.australia",
                title: "Destinations",
                value: "50+",
                color: .green
            )
            
            StatCard(
                icon: "star.fill",
                title: "Rating",
                value: "4.8",
                color: .orange
            )
        }
    }
    
    // MARK: - Recent Searches Section
    @ViewBuilder
    private var recentSearchesSection: some View {
        if !viewModel.recentSearches.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Recent Searches")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button("Clear All") {
                        viewModel.clearRecentSearches()
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
                
                VStack(spacing: 12) {
                    ForEach(viewModel.recentSearches.prefix(3), id: \.id) { search in
                        RecentSearchRow(search: search) {
                            // Handle recent search tap
                            selectedTab = 1
                        }
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
    
    // MARK: - My Trips View
    @ViewBuilder
    private var myTripsView: some View {
        MyTripsDetailView()
            .environmentObject(bookingManager)
    }
    
    // MARK: - Profile View
    @ViewBuilder
    private var profileView: some View {
        ProfileView()
            .environmentObject(bookingManager)
        
    }
}

// MARK: - Supporting Components

struct PopularDestinationCard: View {
    let destination: PopularDestination
    
    var body: some View {
        VStack(spacing: 8) {
            Image(destination.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 80)
                .cornerRadius(12)
                .clipped()
            
            VStack(spacing: 4) {
                Text(destination.city)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(destination.code)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("from ₹\(destination.startingPrice)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 120)
        .padding(8)
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct StatCard: View {
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
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct RecentSearchRow: View {
    let search: RecentSearch
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(search.from) → \(search.to)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(search.date, style: .date)
                        Text("•")
                        Text("\(search.passengers) passenger\(search.passengers > 1 ? "s" : "")")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
