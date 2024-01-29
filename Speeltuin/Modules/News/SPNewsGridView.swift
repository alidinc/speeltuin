//
//  SPNewsGridView.swift
//  Speeltuin
//
//  Created by alidinc on 30/01/2024.
//

import SwiftData
import SwiftUI

struct SPNewsGridView: View {
    
    var item: SPNews
    let dataManager: DataManager
    var onSelect: () -> Void
    
    @Query(animation: .easeInOut) private var savedNews: [SPNews]
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @State private var showAlert = false
    
    var body: some View {
        Button {
            onSelect()
        } label: {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.system(size: 12, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                   
                Spacer()
                
                if let details = item.details {
                    Text(details)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(5)
                }
            }
            .padding(.horizontal, 4)
            .padding(.top, 18)
            .padding(.bottom, 6)
            .frame(width: AsyncImageType.gridNews.width,
                   height: AsyncImageType.gridNews.height)
            .background(
                LinearGradient(colors: [appTint.opacity(0.5), .black.opacity(0.75), .black],
                               startPoint: .top,
                               endPoint: .center),
                in: .rect(cornerRadius: 5)
            )
            .contextMenu(menuItems: {
                Button(role: .destructive) {
                    if self.savedNews.compactMap({$0.persistentModelID}).contains(item.persistentModelID) {
                        showAlert = true
                    }
                } label: {
                    Label("Delete", systemImage: "bookmark")
                }
            })
            .alert("It's already saved!", isPresented: $showAlert) {
                Button(role: .destructive) {
                    if let newsToDelete = savedNews.first(where: {$0.title == item.title }) {
                        modelContext.delete(newsToDelete)
                    }
                    
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
                    }
                } label: {
                    Text("Delete")
                }

                Button(role: .cancel) {
                    
                } label: {
                    Label("Cancel", systemImage: "checkmark")
                }
            } message: {
                Text("Would you like to delete it?")
            }
        }
    }
}
