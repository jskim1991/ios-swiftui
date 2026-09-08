//
//  ContentView.swift
//  news-app
//
//  Created by jay on 9/8/26.
//

import SwiftUI
import WebKit

struct CardView: View {
    var title: String
    var desc: String
    var author: String
    var imageUrl: String?
    
    var body: some View {
        VStack {
            AsyncImage(url: imageUrl.flatMap(URL.init(string:))) { image in
                image.resizable()
                    .scaledToFit()
                
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }.clipped()
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(author)
                    .font(.subheadline)
                
                Text(desc)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.leading)
        }
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: 30))
        .background {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(.white)
                .shadow(radius: 5)
        }
        .padding(10)
    }
}

struct ContentView: View {
    let repository: NewsRepository
    
    @State private var news: News = .init(status: "", totalResults: 0, articles: [])
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if let errorMessage {
                    ContentUnavailableView(
                        "No News",
                        systemImage: "wifi.slash",
                        description: Text(errorMessage)
                    )
                } else {
                    List(news.articles) { article in
                        ZStack {
                            NavigationLink(value: article.url) {
                                EmptyView()
                            }
                            .opacity(0)
                            CardView(
                                title: article.title ?? "",
                                desc: article.description ?? "",
                                author: article.author ?? article.source.name,
                                imageUrl: article.urlToImage
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Jay News")
            .task {
                await fetchNews()
            }
            .refreshable {
                await fetchNews()
            }
            .navigationDestination(for: String.self) { value in
                WebView(url: URL(string: value)!)
            }
        }
    }
    
    func fetchNews() async {
        do {
            news = try await repository.topHeadlines()
            errorMessage = nil
        } catch is CancellationError {
            return
        } catch {
            errorMessage = "Couldn't load news. Pull to refresh."
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        .init()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

#Preview {
    ContentView(repository: DefaultNewsRepository(
        manager: NetworkClient.shared,
        apiKey: AppConfig.newsAPIKey
    ))
}
