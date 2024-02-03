//
//  GameDetailView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 07/01/2024.
//

import SwiftUI

enum DetailType {
    case deeplink
    case standard
}


struct GameDetailView: View {
    
    var game: Game?
    var savedGame: SPGame?
    let dataManager: DataManager
    
    @State var vm = GameDetailViewModel()
    @State private var isExpanded = false
    @State private var gameToAddForNewLibrary: Game?
    @State private var showAddLibraryWithNoGame = false
    var type: DetailType = .standard
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(Admin.self) private var admin
    
    init(game: Game, dataManager: DataManager, type: DetailType = .standard) {
        self.game = game
        self.dataManager = dataManager
        self.type = type
    }
    
    init(savedGame: SPGame, dataManager: DataManager, type: DetailType = .standard) {
        self.dataManager = dataManager
        self.type = type
        if let game = savedGame.game {
            self.game = game
            self.savedGame = savedGame
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                GameImage
                
                if let game {
                    VStack(alignment: .leading, spacing: 25) {
                        Header(game: game)
                        SummaryView(game: game)
                        DetailsView(game: game)
                        VideosView(game: game)
                        
                        if !vm.gamesFromIds.isEmpty {
                            SimilarGamesView(similarGames: vm.gamesFromIds, dataManager: dataManager)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal)
                    .task {
                        if let similarGames = game.similarGames {
                            await vm.fetchGames(from: similarGames)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 1)
        .background(.gray.opacity(0.15))
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: (savedGame?.imageData != nil) || (game != nil) ? .top : .leading)
        .onReceive(NotificationCenter.default.publisher(for: .newLibraryButtonTapped), perform: { notification in
            if let game = notification.object as? Game {
                gameToAddForNewLibrary = game
            } else {
                withAnimation {
                    showAddLibraryWithNoGame = true
                }
            }
        })
        .sheet(item: $gameToAddForNewLibrary, content: { game in
            AddLibraryView(game: game, dataManager: dataManager).presentationDetents([.medium, .large])
        })
        .sheet(isPresented: $showAddLibraryWithNoGame) {
            AddLibraryView(dataManager: dataManager).presentationDetents([.medium, .large])
        }
        .toolbar {
            if type == .standard {
                ToolbarItem(placement: .topBarTrailing) {
                    if let gameId = game?.id, let url = URL(string: "speeltuin://\(gameId)") {
                        if let game, let name = game.name, let imageURLString = game.cover?.url, let imageURL = URL(string: imageURLString) {
                            ShareLink(item: url,
                                      message: Text("Please check this out!"),
                                      preview:
                                        SharePreview("\(name)",
                                                     
                                                     icon: Image(.teal)
                                                    )
                            ) {
                                Image(systemName: "square.and.arrow.up.fill")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    private func Header(game: Game) -> some View {
        VStack(alignment: .leading) {
            if let name = game.name {
                HStack {
                    Text(name)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    SavingButton(game: game,
                                 config: .init(opacity: 0.25),
                                 dataManager: dataManager)
                }
            }
            
            RatingView(game: game)
        }
    }
    
    
    @ViewBuilder
    private var GameImage: some View {
        switch admin.networkStatus {
        case .available:
            if let game {
                ImagesView(game: game)
                    .ignoresSafeArea()
                    .fadeOutSides(length: 100, side: .bottom)
                    .overlay(alignment: .bottomLeading) {
                        FeatureGameImage(game: game)
                    }
                    .overlay(alignment: .topTrailing) {
                        if type == .deeplink {
                            CloseButton()
                                .padding()
                        }
                    }
            }
        case .unavailable:
            if let savedGame, let imageData = savedGame.imageData {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.size.width,
                               height: UIScreen.main.bounds.size.height * 0.6)
                        .ignoresSafeArea(edges: .top)
                        .fadeOutSides(length: 100, side: .bottom)
                        .overlay(alignment: .bottomLeading) {
                            if let game = savedGame.game {
                                FeatureGameImage(game: game)
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            if type == .deeplink {
                                CloseButton()
                                    .padding()
                            }
                        }
                }
            }
        }
    }
    
    private func DetailsView(game: Game) -> some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 30) {
                GenresView(game: game)
                PlatformsView(game: game)
                GameModesView(game: game)
                SocialsView(game: game)
            }
        } label: {
            Text(isExpanded ? "" : "Details")
                .font(.subheadline.bold())
                .foregroundColor(.primary)
        }
        .padding()
        .background(colorScheme == .dark ? .ultraThickMaterial : .ultraThick, in: .rect(cornerRadius: 10))
        .shadow(radius: 2)
        .onChange(of: isExpanded) { oldValue, newValue in
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        }
    }
}
