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
    
    @Environment(\.colorScheme) var colorScheme
    
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
            VStack {
                Divider()
                DisclosureGroup {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(self.videoURLs, id: \.self) { id in
                                YoutubeVideoView(youtubeVideoID: id)
                            }
                            .frame(width: 120, height: 80)
                            .clipShape(.rect(cornerRadius: 8))
                            .padding(.bottom)
                            .padding(.leading)
                        }
                    }
                    .padding(.top)
                } label: {
                    Text("Videos")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                        .padding(.leading)
                }
            }
            .padding(.vertical, 6)
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
