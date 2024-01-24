//
//  NewsViewModel.swift
//  Speeltuin
//
//  Created by Ali Dinç on 06/01/2024.
//

import SwiftUI
import Observation
import FeedKit

@Observable
class NewsViewModel {
    
    private var bag = Bag()
    
    var allNews: [RSSFeedItem] = []
    var ign: [RSSFeedItem] = []
    var nintendo: [RSSFeedItem] = []
    var xbox: [RSSFeedItem] = []
    
    var newsType: NewsType = .all
    
    func groupedAndSortedItems(items: [RSSFeedItem]) -> [(String, [RSSFeedItem])] {
        let groupedItems = Dictionary(grouping: items) { item in
            // Customize the date format based on your needs
            let dateFormatter = DateFormatter()
            //  dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: item.pubDate ?? Date())
        }
        
        return groupedItems.sorted(by: { $0.0 > $1.0 })
    }
    
    func fetchNews() async {
        for type in [NewsType.ign, NewsType.nintendo, NewsType.xbox] {
            guard let url = URL(string: type.urlString) else {
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .sink { _ in
                   
                } receiveValue: { response in
                    let parser = FeedParser(data: response)
                    parser.parseAsync { [weak self] result in
                        guard let self else {
                            return
                        }
                        
                        switch result {
                        case .success(let feed):
                            self.setItems(type: type, feed: feed)
                        case .failure(let failure):
                            print(failure.localizedDescription)
                        }
                    }
                }
                .store(in: &bag)
        }
    }
    
    func setItems(type: NewsType, feed: Feed) {
        if let items = feed.rssFeed?.items {
            switch type {
            case .ign:
                self.ign = items
                self.allNews.append(contentsOf: items)
            case .nintendo:
                self.nintendo = items
                self.allNews.append(contentsOf: items)
            case .xbox:
                self.xbox = items
                self.allNews.append(contentsOf: items)
            case .all:
                break
            }
        }
    }
}