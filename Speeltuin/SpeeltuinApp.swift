//
//  Speeltuin.swift
//  Speeltuin
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI

@main
struct SpeeltuinApp: App {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("appTint")     private var appTint: Color = .blue
    @AppStorage("colorScheme") private var scheme: SchemeType = .system
    
    @Environment(\.dismiss) var dismiss
    
    @State private var preferences = Admin()
    @State private var gamesViewModel = GamesViewModel()
    @State private var newsViewModel = NewsViewModel()
    
    @State private var activeTab: Tab = .games
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                IntroView()
                    .preferredColorScheme(.dark)
            } else {
                UIKitTabView([
                    UIKitTabView.Tab(view:
                                        GamesTab(vm: gamesViewModel),
                                     barItem: UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller.fill"), tag: 0)),
                    UIKitTabView.Tab(view:
                                        NewsTab(vm: newsViewModel),
                                     barItem: UITabBarItem(title: "News", image: UIImage(systemName: "newspaper.fill"), tag: 1)),
                    UIKitTabView.Tab(view:
                                        MoreTab(),
                                     barItem: UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis.circle.fill"), tag: 1)),
                ])
                .tint(appTint)
                .environment(preferences)
                .environment(gamesViewModel)
                .environment(newsViewModel)
                .preferredColorScheme(setColorScheme())
            }
        }
        .modelContainer(
            for: [
                Library.self,
                SavedGame.self,
                SavedNews.self
            ],
            inMemory: false
        )
    }
    
    func setColorScheme() -> ColorScheme? {
        switch self.scheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

var didRemoteChange = NotificationCenter
    .default
    .publisher(for: .NSPersistentStoreRemoteChange)
    .receive(on: RunLoop.main)
