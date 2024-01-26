//
//  AllLibrariesView.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import SwiftData
import SwiftUI

struct AllLibrariesView: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    
    @Query(animation: .easeInOut) var libraries: [Library]
    @Query(animation: .easeInOut) var savedGames: [SavedGame]
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Environment(GamesViewModel.self) private var gamesVM: GamesViewModel
    
    @State private var libraryToEdit: Library?
    @State private var libraryToDelete: Library?
    @State private var showAlertToDeleteLibrary = false
    
    var body: some View {
        List {
            ForEach(libraries, id: \.savingId) { library in
                Button(action: {
                    gamesVM.librarySelectionTapped(allSelected: false, for: library, in: savedGames)
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
                    }
                    dismiss()
                }, label: {
                    LibraryView(library)
                })
                .padding()
                .hSpacing(.leading)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .sheet(item: $libraryToEdit, content: { library in
                    EditLibraryView(library: library)
                        .presentationDetents([.fraction(0.7)])
                })
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        libraryToDelete = library
                        showAlertToDeleteLibrary = true
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                    .tint(.red)
                    
                    
                    Button(role: .destructive) {
                        libraryToEdit = library
                        if hapticsEnabled {
                            HapticsManager.shared.vibrateForSelection()
                        }
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.orange)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .alert(Constants.Alert.deleteLibraryAlertTitle, isPresented: $showAlertToDeleteLibrary, actions: {
            Button(role: .destructive) {
                if let libraryToDelete, libraries.contains(libraryToDelete) {
                    context.delete(libraryToDelete)
                }
            } label: {
                Text(Constants.Alert.delete)
            }
            
            Button(role: .cancel) {
                
            } label: {
                Text(Constants.Alert.cancel)
            }
        }, message: {
            Text(Constants.Alert.undoAlertTitle)
        })
    }
    
    
    private func LibraryView(_ library: Library) -> some View {
        HStack {
            Image(systemName: library.icon)
                .imageScale(.medium)
            
            Text(library.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            if let savedGames = library.savedGames {
                Text("\(savedGames.count) games")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
