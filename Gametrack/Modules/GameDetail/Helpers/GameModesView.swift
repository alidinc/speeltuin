//
//  GameModesView.swift
//  Gametrack
//
//  Created by Ali Dinç on 29/12/2023.
//

import SwiftUI

struct GameModesView: View {
    
    var game: Game
    
    @AppStorage("appTint") var appTint: Color = .white
    
    var body: some View {
        if let gameModes = game.gameModes {
            VStack(alignment: .leading) {
                Text("Available modes")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(gameModes, id: \.id) { mode in
                            if let id = mode.id, let availableMode = AvailableMode(rawValue: id) {
                                HStack {
                                    Image(systemName: availableMode.imageName)
                                        .imageScale(.small)
                                    
                                    Text(availableMode.title)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(10)
                                .foregroundStyle(.secondary)
                                .background(.ultraThinMaterial, in: .capsule)
                            }
                        }
                    }
                }
            }
        }
    }
}


enum AvailableMode: Int, CaseIterable {
    case single = 1
    case multi = 2
    case coop = 3
    case split = 4
    case massive = 5
    case battle = 6
    
    var id: Int {
        switch self {
        default:
            return self.rawValue
        }
    }
    
    var title: String {
        switch self {
        case .single:
            return "Single player"
        case .multi:
            return "Multi-player"
        case .coop:
            return "Co-operative"
        case .split:
            return "Split screen"
        case .massive:
            return "Massively Multiplayer Online (MMO)"
        case .battle:
            return "Battle Royale"
        }
    }
    
    var imageName: String {
        switch self {
        case .single:
            return "person.fill"
        case .multi:
            return "person.2.fill"
        case .coop:
            return "person.2.circle.fill"
        case .split:
            return "rectangle.split.2x1.fill"
        case .massive:
            return "person.3.fill"
        case .battle:
            return "shield.checkered"
        }
    }
}
