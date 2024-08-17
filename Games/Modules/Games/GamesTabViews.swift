//
//  GamesTabViews.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

extension MainView {
    
    var Header: some View {
        VStack {
            HStack(alignment: .center) {
                MultiPicker
                if contentType == .games {
                    SearchButton
                }
                Spacer()
                FiltersButton
            }

            if showSearch {
                SearchTextField(
                    searchQuery: $vm.searchQuery,
                    prompt: vm.searchPlaceholder,
                    isFocused: $isTextFieldFocused
                )
            }
        }
        .labelStyle()
        .padding(.horizontal)
    }
    
    var LibraryButton: some View {
        NavigationLink {
            LibrariesView()
        } label: {
            SFImage(
                config: .init(
                    name: "tray.full.fill",
                    padding: 10,
                    color: .primary
                )
            )
        }
    }
    
    var FiltersButton: some View {
        Menu {
            switch contentType {
            case .games:
                Menu {
                    ForEach(Category.allCases) { category in
                        Button(category.title, systemImage: category.systemImage) {
                            vm.fetchTaskToken.category = category
                        }
                    }
                } label: {
                    Text("Category")
                }

                Divider()

                Menu {
                    let platforms = PopularPlatform.allCases.filter({$0 != PopularPlatform.database }).sorted(by: { $0.title < $1.title })

                    ForEach(platforms) { platform in
                        Button {
                            if hapticsEnabled {
                                HapticsManager.shared.vibrateForSelection()
                            }
                            vm.togglePlatform(platform, selectedLibrary: vm.selectedLibrary, savedGames: savedGames)
                        } label: {
                            HStack {
                                Text(platform.title)
                                if vm.fetchTaskToken.platforms.contains(platform) {
                                    Image(systemName: "checkmark")
                                }
                                Image(platform.assetName)
                            }
                        }
                    }
                } label: {
                    Text("Platform")
                }

                Divider()

                Menu {
                    let genres = PopularGenre.allCases.filter({$0 != PopularGenre.allGenres }).sorted(by: { $0.title < $1.title })

                    ForEach(genres) { genre in
                        Button {
                            if hapticsEnabled {
                                HapticsManager.shared.vibrateForSelection()
                            }
                            vm.toggleGenre(genre, selectedLibrary: vm.selectedLibrary, savedGames: savedGames)
                        } label: {
                            HStack {
                                Text(genre.title)
                                if vm.fetchTaskToken.genres.contains(genre) {
                                    Image(systemName: "checkmark")
                                }
                                Image(genre.assetName)
                            }
                        }
                    }
                } label: {
                    Text("Genre")
                }

                Divider()

                Button(role: .destructive) {
                    vm.fetchTaskToken.platforms = []
                    vm.fetchTaskToken.genres = []
                } label: {
                    Text("Remove filters")
                }

            case .news:
                ForEach(NewsType.allCases) { news in
                    Button {
                        newsVM.newsType = news
                    } label: {
                        Text(news.title)
                    }
                }
            case .library:
                Text("Showing libraries")
            }
        } label: {
            SFImage(
                config: .init(
                    name: "slider.horizontal.3",
                    padding: 10,
                    color: .primary
                )
            )
        }
        .animation(.bouncy, value: vm.hasFilters)
    }
    
    var SearchButton: some View {
        Button {
            withAnimation(.bouncy) {
                showSearch.toggle()
            }
            
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        } label: {
            SFImage(
                config: .init(
                    name: "magnifyingglass",
                    padding: 10,
                    color: .primary
                )
            )
        }
        .transition(.move(edge: .top))
    }
    
    var MultiPicker: some View {
        Button {
            self.contentType = self.contentType == .games ? .news : .games
        } label: {
            Image(systemName: contentType.imageName)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
    
    var CategoryPicker: some View {
        Menu {
            ForEach(Category.allCases, id: \.id) { category in
                Button {
                    vm.categorySelected(for: category)
                    if hapticsEnabled {
                        HapticsManager.shared.vibrateForSelection()
                    }
                } label: {
                    Text(category.title)
                }
                .tag(category)
            }
        } label: {
            Text("Internet")
        }
    }
}

