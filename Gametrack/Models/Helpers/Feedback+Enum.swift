//
//  Feedback+Enum.swift
//  goodgames
//
//  Created by Ali Dinc on 22/02/2023.
//

import SwiftUI

enum Feedback: Int, CaseIterable, Equatable, Hashable {
    case email
    case rate
    case share
    
    var id: Int {
        switch self {
        default:
            return self.rawValue
        }
    }
    
    var title: String {
        switch self {
        case .email:
            return "Send an email"
        case .rate:
            return "Rate us on the AppStore"
        case .share:
            return "Tell a friend"
        }
    }
    
    var imageName: String {
        switch self {
        case .email:
            return "paperplane.circle.fill"
        case .rate:
            return "heart.circle.fill"
        case .share:
            return "square.and.arrow.up.circle.fill"
        }
    }
    
    var imageColor: Color {
        switch self {
        case .email:
            return Color.teal
        case .rate:
            return Color.cyan
        case .share:
            return Color.blue
        }
    }
}
