//
//  VideosView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 24/12/2023.
//

import SwiftUI
import AVKit

struct VideosView: View {
    
    var game: Game
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    var videoURLs: [String] {
        var urls = [String]()
        guard let videos = self.game.videos?.compactMap({$0.videoID ?? ""}) else {
            return []
        }
        
        for url in videos {
            urls.append(url)
        }
        return urls
    }
    
    var body: some View {
        if !self.videoURLs.isEmpty {
            DisclosureGroup(isExpanded: $isExpanded) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(self.videoURLs, id: \.self) { id in
                            YoutubeVideoView(youtubeVideoID: id)
                        }
                        .frame(width: 300, height: 170)
                        .clipShape(.rect(cornerRadius: 8))
                    }
                }
                .padding(.top)
            } label: {
                Text("Videos")
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
}


import SwiftUI
import WebKit

struct YoutubeVideoView: UIViewRepresentable {
    
    @State var youtubeVideoID: String
    
    func makeUIView(context: Context) -> WKWebView  {
        let configuration = WKWebViewConfiguration()
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.allowsInlineMediaPlayback = false
        return WKWebView(frame: .zero, configuration: configuration)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let path = "https://www.youtube.com/embed/\(youtubeVideoID)"
        guard let url = URL(string: path) else { return }
        let request = URLRequest(url: url)
        
        webView.scrollView.isScrollEnabled = false
        webView.load(request)
    }
}