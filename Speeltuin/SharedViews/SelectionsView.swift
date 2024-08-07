//
//  CustomSegmentedView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 20/12/2023.
//

import SwiftData
import SwiftUI

struct SelectionsView: View {
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("appTint")        var appTint: Color = .blue
    @AppStorage("colorScheme") var scheme: SchemeType = .system
    
    @Environment(GamesViewModel.self) private var vm: GamesViewModel
    @State var selectedOption: SelectionOption = .platform
    @Namespace private var animation
    
    @Query private var savedGames: [SPGame]
    @Query private var savedLibraries: [SPLibrary]
    
    var body: some View {
        VStack(spacing: 0) {
            Header
            SegmentedView(
                          selectedSegment: $selectedOption,
                          segments: SelectionOption.allCases,
                          segmentContent: { item in
                Text(item.rawValue.capitalized)
            })
            
            OptionsView
        }
        .presentationDragIndicator(.visible)
    }
    
    private var Header: some View {
        HStack {
            VStack {
                Text("Select your \(selectedOption.rawValue)s")
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .hSpacing(.leading)
                
                if selectedOption == .platform || selectedOption == .genre {
                    Text("You can select multiple options.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .hSpacing(.leading)
                } else {
                    Text("This is a category based on the data.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .hSpacing(.leading)
                }
            }
            
            
            ClearFiltersButton
                .animation(.bouncy, value: vm.hasFilters)
                .padding(.trailing)
            
            CloseButton()
        }
        .padding(20)
    }
    
    @ViewBuilder
    private var ClearFiltersButton: some View {
        Button {
            if vm.hasFilters {
                vm.removeFilters()
            }
            
            if hapticsEnabled {
                HapticsManager.shared.vibrateForSelection()
            }
        } label: {
            Image(systemName: vm.hasFilters ? "slider.horizontal.2.gobackward" : "slider.horizontal.3")
                .foregroundStyle(vm.hasFilters ? appTint : .secondary)
                .symbolEffect(.bounce, value: vm.hasFilters)
                .font(.title3)
        }
    }
    
    private var OptionsView: some View {
        VStack {
            let platforms = PopularPlatform.allCases.filter({$0 != PopularPlatform.database }).sorted(by: { $0.title < $1.title })
            let genres = PopularGenre.allCases.filter({$0 != PopularGenre.allGenres }).sorted(by: { $0.title < $1.title })
            let columns = Array(repeating: GridItem(), count: 4)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    switch selectedOption {
                    case .platform:
                        ForEach(platforms) { platform in
                            Button {
                                if hapticsEnabled {
                                    HapticsManager.shared.vibrateForSelection()
                                }
                                vm.togglePlatform(platform, selectedLibrary: vm.selectedLibrary, savedGames: savedGames)
                            } label: {
                                OptionTileView(imageName: platform.assetName,
                                               title: platform.title,
                                               isSelected: vm.fetchTaskToken.platforms.contains(platform))
                            }
                        }
                    case .genre:
                        ForEach(genres) { genre in
                            Button {
                                if hapticsEnabled {
                                    HapticsManager.shared.vibrateForSelection()
                                }
                                vm.toggleGenre(genre, selectedLibrary: vm.selectedLibrary, savedGames: savedGames)
                            } label: {
                                OptionTileView(imageName: genre.assetName,
                                               title: genre.title,
                                               isSelected: vm.fetchTaskToken.genres.contains(genre))
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func OptionTileView(imageName: String, title: String, isSelected: Bool) -> some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .opacity(isSelected ? 1 : 0.5)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(Color(uiColor: .label))
                .opacity(isSelected ? 1 : 0.5)
                .multilineTextAlignment(.center)
        }
        .frame(height: 70)
        .hSpacing(.center)
        .vSpacing(.center)
        .animation(.interactiveSpring(), value: isSelected)
        .padding(10)
        .background(Color.segmentOptionSelectedBackground, in: .rect(cornerRadius: 10))
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(appTint, lineWidth: 2)
            }
        }
    }
}
