//
//  SummaryView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 25/12/2023.
//

import SwiftUI

struct SummaryView: View {
    
    var game: Game
    @State private var showMore = false
    
    var body: some View {
        if let summary = game.summary {
            Group {
                Text("\(showMore ? summary : String(summary.prefix(250)))")
                    .foregroundStyle(.primary)
                   
              +   Text(showMore || (summary.count < 250) ? "" : " ... more")
                    .foregroundStyle(.blue)
            }
            .font(.subheadline)
            .onTapGesture {
                withAnimation {
                    showMore.toggle()
                }
            }
            
        }
    }
}
