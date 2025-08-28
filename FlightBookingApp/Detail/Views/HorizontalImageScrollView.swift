//
//  HorizontalImageScrollView.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

struct HorizontalImageScrollView: View {
   
    let imageNames: [String] = ["offer1", "offer2", "offer3", "offer4", "offer5"]
    @State private var currentIndex: Int = 0
    @State private var isUserInteracting: Bool = false
    @State private var pauseAutoScroll: Bool = false
    @State private var dragOffset: CGFloat = 0
    
    private let autoScrollInterval: TimeInterval = 4.0
    private let pauseDurationAfterInteraction: TimeInterval = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
        
            // Main scroll view
            GeometryReader { geometry in
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 15) {
                            ForEach(imageNames.indices, id: \.self) { index in
                                ImageCard(
                                    imageName: imageNames[index],
                                    width: geometry.size.width * 0.85,
                                    isActive: index == currentIndex
                                )
                                .id(index)
                                .onTapGesture {
                                    handleImageTap(index: index)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in
//                                dragOffset = value.translation.x
                                handleUserInteraction()
                            }
                            .onEnded { value in
                                dragOffset = 0
                                handleSwipeGesture(value: value, scrollProxy: scrollProxy)
                            }
                    )
                    .onReceive(Timer.publish(every: autoScrollInterval, on: .main, in: .common).autoconnect()) { _ in
                        if !pauseAutoScroll && !isUserInteracting {
                            autoScrollToNext(scrollProxy: scrollProxy)
                        }
                    }
                    .onChange(of: currentIndex) { newIndex in
                        withAnimation(.easeInOut(duration: 0.6)) {
                            scrollProxy.scrollTo(newIndex, anchor: .center)
                        }
                    }
                }
            }
            .frame(height: 200)
            
            // Enhanced dots indicator
            HStack(spacing: 8) {
                ForEach(imageNames.indices, id: \.self) { index in
                    DotIndicator(
                        isActive: index == currentIndex,
                        index: index
                    ) {
                        handleUserInteraction()
                        currentIndex = index
                    }
                }
            }
            .padding(.top, 12)
        }
        .onAppear {
            startAutoScroll()
        }
        .onDisappear {
            pauseAutoScroll = true
        }
    }
    
    // MARK: - Helper Functions
    
    private func autoScrollToNext(scrollProxy: ScrollViewProxy) {
        let nextIndex = (currentIndex + 1) % imageNames.count
        currentIndex = nextIndex
    }
    
    private func handleUserInteraction() {
        isUserInteracting = true
        pauseAutoScroll = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + pauseDurationAfterInteraction) {
            isUserInteracting = false
            pauseAutoScroll = false
        }
    }
    
    private func handleSwipeGesture(value: DragGesture.Value, scrollProxy: ScrollViewProxy) {
        let swipeThreshold: CGFloat = 50
        
//        if value.translation.x > swipeThreshold && currentIndex > 0 {
//            // Swipe right - go to previous
//            currentIndex -= 1
//        } else if value.translation.x < -swipeThreshold && currentIndex < imageNames.count - 1 {
//            // Swipe left - go to next
//            currentIndex += 1
//        }
    }
    
    private func handleImageTap(index: Int) {
        handleUserInteraction()
        if index != currentIndex {
            currentIndex = index
        }
        // Here you can add navigation or show detail view
        print("Tapped on offer \(index + 1)")
    }
    
    private func startAutoScroll() {
        pauseAutoScroll = false
    }
}

// MARK: - Supporting Components

struct ImageCard: View {
    let imageName: String
    let width: CGFloat
    let isActive: Bool
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: 200)
            .cornerRadius(16)
            .clipped()
            .scaleEffect(isActive ? 1.0 : 0.95)
            .shadow(
                color: Color.black.opacity(isActive ? 0.3 : 0.15),
                radius: isActive ? 12 : 6,
                x: 0,
                y: isActive ? 6 : 3
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: isActive ? [Color.blue.opacity(0.6), Color.purple.opacity(0.6)] : [Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isActive ? 2 : 0
                    )
            )
            .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}

struct DotIndicator: View {
    let isActive: Bool
    let index: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: isActive ? [Color.blue, Color.purple] : [Color.gray.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: isActive ? 12 : 8, height: isActive ? 12 : 8)
                .scaleEffect(isActive ? 1.2 : 1.0)
                .shadow(color: isActive ? Color.blue.opacity(0.4) : Color.clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isActive)
    }
}

#Preview("Enhanced Auto-Scroll") {
    HorizontalImageScrollView()
}
