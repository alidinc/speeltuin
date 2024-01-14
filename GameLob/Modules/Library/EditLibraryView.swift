//
//  EditLibraryView.swift
//  JustGames
//
//  Created by Ali Dinç on 13/01/2024.
//

import SwiftData
import SwiftUI

struct EditLibraryView: View {
    
    @AppStorage("appTint") var appTint: Color = .white
    @Bindable var library: Library
    @Environment(SavingViewModel.self) private var vm: SavingViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query var libraries: [Library]
  
    @State private var showMaxLibraryAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NameView
                    IconSelectionView
                }
                .vSpacing(.top)
            }
            .navigationTitle("Edit library")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                UpdateButton
                    .safeAreaPadding(.bottom)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton()
                }
            }
        }
        .alert("You can't have more than 10 libraries.", isPresented: $showMaxLibraryAlert) {
            Button(action: {}, label: {
                Text("OK")
            })
        }
    }
    
    private var NameView: some View {
        TextField("Name", text: $library.title)
            .frame(height: 24, alignment: .leading)
            .padding()
            .clipShape(.rect(cornerRadius: 8))
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
            .padding(.horizontal)
            .autocorrectionDisabled()
    }
    
    private var IconSelectionView: some View {
        DisclosureGroup {
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], content: {
                    ForEach(SFModels.allSymbols, id: \.self) { symbol in
                        Button(action: {
                            library.icon = symbol
                        }, label: {
                            Image(systemName: symbol)
                                .padding()
                                .imageScale(.medium)
                                .overlay {
                                    if symbol == library.icon {
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(appTint, lineWidth: 2)
                                    }
                                }
                        })
                    }
                })
                .padding(.horizontal)
            }
            .frame(height: 175)
           
        } label: {
            HStack {
                Text("Selected icon")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if let icon = library.icon {
                    SFImage(name: icon, opacity: 0.5)
                }
                
            }
            .padding(.vertical, 4)
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
        .padding(.horizontal)
    }
    
    private var UpdateButton: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "arrow.2.squarepath")
                Text("Update")
            }
            .hSpacing(.center)
            .foregroundStyle(.white)
            .bold()
            .padding()
            .background(.blue, in: .capsule)
        }
        .padding(.horizontal)
    }
}