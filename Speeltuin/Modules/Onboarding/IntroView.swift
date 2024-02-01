//
//  IntroView.swift
//  Speeltuin
//
//  Created by alidinc on 22/01/2024.
//

import SwiftUI

struct IntroView: View {
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("appTint") var appTint: Color =  .blue
    @AppStorage("selectedIcon") private var selectedAppIcon: DeviceAppIcon = .system
    
    @State private var animating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Image(selectedAppIcon.title.lowercased())
                .resizable()
                .frame(width: 70, height: 70)
                .scaledToFit()
               
            Text("Speeltuin: \nYour hub for organising and saving games in personalised libraries.")
                .font(.title.bold())
                .multilineTextAlignment(.leading)
                .padding(.bottom, 35)
            
            /// Points view
            VStack(alignment: .leading, spacing: 25) {
                PointView(
                    symbol: "folder.fill",
                    title: "Information",
                    subtitle: "Effortlessly curate and access your games."
                )
                
                PointView(
                    symbol: "wand.and.stars",
                    title: "Visually stunning",
                    subtitle: "Say goodbye to scattered game lists."
                )
                
                PointView(
                    symbol: "magnifyingglass",
                    title: "Advance Filters",
                    subtitle: "Find the games you want by advance search and filtering."
                )
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            
            Spacer()
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 80)
        .background(
            LinearGradient(colors: [.clear, .gray.opacity(0.5)], startPoint: .bottom, endPoint: .top)
        )
        .onAppear {
            animating = true
        }
        .safeAreaInset(edge: .bottom) {
            Button("Get Started") {
                isFirstTime = false
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(appTint.gradient, in: .capsule)
            .fontWeight(.bold)
            .padding(20)
        }
    }
    
    /// Point view
    @ViewBuilder
    func PointView(symbol: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .frame(width: 45)
                .symbolEffect(.pulse, options: .repeating, isActive: animating)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
