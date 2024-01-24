//
//  SavingButton.swift
//  Speeltuin
//
//  Created by Ali Dinç on 30/12/2023.
//

import SwiftData
import SwiftUI
import Combine

struct SavingButton: View {
    
    var game: Game
    var opacity: CGFloat
    
    @AppStorage("appTint") var appTint: Color = .white
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    @Environment(\.modelContext) private var context
    
    @Query var games: [SavedGame]
    @Query var libraries: [Library]
    
    var body: some View {
        Menu {
            let libraries = libraries.filter({ !($0.savedGames?.compactMap({$0.game}).contains(game) ?? false) })
            if !libraries.isEmpty {
                Label("Add to : ", systemImage: "arrow.turn.right.down")
            }
            
            ForEach(libraries, id: \.savingId) { library in
                Button {
                    let dataManager = SwiftDataManager(modelContainer: context.container)
                    Task {
                        await dataManager.setLibrary(library: library)
                        await dataManager.toggle(game: game)
                    }
                } label: {
                    HStack {
                        Image(systemName: library.icon)
                            .imageScale(.medium)
                        
                        Text(library.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
            }
            
            Divider()
            
            Button(action: {
                NotificationCenter.default.post(name: .newLibraryButtonTapped, object: game)
            }, label: {
                Label("New library", systemImage: "plus")
            })
            .tint(appTint)
            
            if games.compactMap({$0.game}).contains(game), let savedGame = games.first(where: {$0.game?.id == game.id }) {
                Button(action: {
                    context.delete(savedGame)
                }, label: {
                    Label("Delete", systemImage: "trash.fill")
                })
                .tint(.red)
            }

        } label: {
            SFImage(
                name: libraryName(),
                config: .init(
                    opacity: opacity,
                    color: appTint
                )
            )
        }
    }
    
    func libraryName() -> String {
        if let library = games.first(where: { $0.game?.id == game.id })?.library {
            return library.icon
        }
        
        return "bookmark"
    }
}
