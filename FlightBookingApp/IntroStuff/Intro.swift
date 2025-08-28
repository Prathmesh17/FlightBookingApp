//
//  Intro.swift
//  ComponentsApp
//
//  Created by Prathmesh Parteki on 16/06/25.
//
import SwiftUI

//MARK: Intro Model and Sample Intro's

struct Intro: Identifiable{
    var id : String = UUID().uuidString
    var imageName : String
    var title : String
    var subtitle : String
}

var intros: [Intro] = [
    .init(
        imageName: "FlightSearch",
        title: "Search & Explore",
        subtitle: "Discover the best flight deals to your favorite destinations with a tap."
    ),
    .init(
        imageName: "BookingProcess",
        title: "Book with Ease",
        subtitle: "Select flights, choose seats, and pay securely – all in one place."
    ),
    .init(
        imageName: "TravelComfort",
        title: "Travel Comfortably",
        subtitle: "Get real-time updates, manage bookings, and enjoy a seamless journey."
    )
]

let dummyText = "Looking for the perfect getaway? Easily search and compare flights to destinations around the world."
