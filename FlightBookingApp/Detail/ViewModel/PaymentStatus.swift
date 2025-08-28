//
//  PaymentStatus.swift
//  FlightBookingApp
//
//  Created by Prathmesh Parteki on 28/08/25.
//

import SwiftUI

enum PaymentStatus: String, CaseIterable {
    case initated = "Payment Initiated"
    case started = "Payment Processing"
    case finished = "Payment Successful"
    
    var symbolImage: String {
        switch self {
        case .initated:
            return "creditcard.fill"
        case .started:
            return "wifi"
        case .finished:
            return "checkmark.circle.fill"
        }
    }
}
