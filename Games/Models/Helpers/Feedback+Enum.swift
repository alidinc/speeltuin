//
//  Feedback+Enum.swift
//  Speeltuin
//
//  Created by Ali Dinc on 22/02/2023.
//

import SwiftUI

enum Feedback: Int, CaseIterable, Equatable, Hashable, Identifiable {
    case email
    case rate
    case tips
    case share
    case about

    var id: Self { self }

    var title: String {
        switch self {
        case .email:
            return "Support"
        case .rate:
            return "Rate"
        case .tips:
            return "Tip Jar"
        case .about:
            return "About"
        case .share:
            return "Share"
        }
    }

    var subtitle: String {
        switch self {
        case .email:
            return "Send us an email"
        case .rate:
            return "Review us on AppStore"
        case .tips:
            return "If you want to support"
        case .about:
            return "More about us"
        case .share:
            return "Thank you for sharing!"
        }
    }

    var imageName: String {
        switch self {
        case .email:
            return "paperplane.fill"
        case .rate:
            return "heart.circle.fill"
        case .tips:
            return "hands.clap.fill"
        case .about:
            return "info.circle.fill"
        case .share:
            return "square.and.arrow.up.fill"
        }
    }
}
