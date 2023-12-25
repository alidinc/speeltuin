//
//  HomeViewModel.swift
//  A-games
//
//  Created by Ali Dinç on 18/12/2023.
//

import SwiftUI
import Observation

@Observable
class HomeViewModel {
    
    var searchQuery = ""
    var fetchTaskToken: FetchTaskToken

    var dataFetchPhase = DataFetchPhase<[Game]>.empty
    
    @ObservationIgnored
    private var newReleasedCache = DiskCache<[Game]>(filename: "NewReleasedGames", expirationInterval: 24 * 60 * 60 * 60)
    
    private var limit = 21
    private var offset = 0
    
    var games: [Game] {
        dataFetchPhase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = dataFetchPhase {
            return true
        }
        return false
    }
    
    var viewNotReady: Bool {
        guard let value1 = self.dataFetchPhase.value else {
            return true
        }
        
        return value1.isEmpty
    }
    
    init() {
        self.fetchTaskToken = FetchTaskToken(
            category: .topRated,
            platforms: [.database],
            genres: [.allGenres],
            token: .now
        )
    }
}

extension HomeViewModel {
    
    @Sendable
    func refreshTask() async {
        self.offset = 0
        self.dataFetchPhase = .empty
        self.fetchTaskToken.token = Date()
        await self.newReleasedCache.removeValue(forKey: self.fetchTaskToken.category.rawValue)
    }
    
    func fetchGames() async {
        if Task.isCancelled { return }
        let category = self.fetchTaskToken.category
        let platforms = self.fetchTaskToken.platforms
        let genres = self.fetchTaskToken.genres
        
        if let games = await self.newReleasedCache.value(forKey: category.rawValue) {
            if Task.isCancelled { return }
            DispatchQueue.main.async {
                self.dataFetchPhase = .success(games)
            }
            return
        }
        
        self.offset = 0
        DispatchQueue.main.async {
            self.dataFetchPhase = .empty
        }
        
        do {
            let response = try await NetworkManager.shared.fetchDetailedGames(query: searchQuery.lowercased(),
                                                                      with: category,
                                                                      platforms: platforms,
                                                                      genres: genres,
                                                                      limit: self.limit,
                                                                      offset: self.offset)
      //      let games = response.first?.result ?? []
            if Task.isCancelled { return }
            
            DispatchQueue.main.async {
                self.dataFetchPhase = .success(response)
            }
            if !games.isEmpty {
                await self.newReleasedCache.setValue(games, forKey: category.rawValue)
            }
        } catch {
            if Task.isCancelled { return }
            DispatchQueue.main.async {
                self.dataFetchPhase = .failure(error)
            }
        }
    }
    
    func fetchNextSetOfGames() async {
        if Task.isCancelled { return }
        let category = self.fetchTaskToken.category
        let platforms = self.fetchTaskToken.platforms
        let genres = self.fetchTaskToken.genres
        let games = self.dataFetchPhase.value ?? []
    
        if Task.isCancelled { return }
        DispatchQueue.main.async {
            self.dataFetchPhase = .fetchingNextPage(games)
        }
        
        do {
            self.offset += self.limit
            let response = try await NetworkManager.shared.fetchDetailedGames(query: searchQuery.lowercased(),
                                                                      with: category,
                                                                      platforms: platforms,
                                                                      genres: genres,
                                                                      limit: self.limit,
                                                                      offset: self.offset)
       //     let newGames = response.first?.result ?? []
            let totalGames = games + response
            if Task.isCancelled { return }
           
            DispatchQueue.main.async {
                self.dataFetchPhase = .success(totalGames)
            }
            if !totalGames.isEmpty {
                await self.newReleasedCache.setValue(totalGames, forKey: category.rawValue)
            }
        } catch {
            if Task.isCancelled { return }
            DispatchQueue.main.async {
                self.dataFetchPhase = .failure(error)
            }
        }
    }
    
    func hasReachedEnd(of game: Game) -> Bool {
        guard let lastGame = games.last  else {
            return false
        }
        
        return (lastGame.id == game.id) && ((games.count - 1) == games.lastIndex(of: game))
    }
}
