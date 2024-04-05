//
//  NewsAPI.swift
//  DialysisPlus
//
//  Created by Meghs on 03/03/24.
//

import SwiftUI
import SafariServices

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let results: [NewsItem]
}

struct NewsItem: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let image_url: String
    let link: String
}

struct NewsCarouselView: View {
    let newsItems: [NewsItem]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(newsItems) { item in
                    NewsCardView(item: item)
                }
            }.padding()
        }
    }
}

struct NewsCardView: View {
    let item: NewsItem
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: item.image_url)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width:150, height: 100)
            .cornerRadius(10)
            
            Text(item.title.prefix(40))
                .font(.headline)
                .multilineTextAlignment(.leading)
                .frame(width: 150)
        }
        .onTapGesture {
            if let url = URL(string: item.link) {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct AsyncImage<Content: View>: View {
    @StateObject private var loader: ImageLoader
    private let content: (Image) -> Content
    
    init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.content = content
    }
    
    var body: some View {
        if let image = loader.image {
            content(image)
        } else {
            content(Image(systemName: "photo"))
                .onAppear(perform: loader.load)
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: Image?
    
    private var url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func load() {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }.resume()
    }
}

struct newsAPITest: View {
    let newsItems = [
        NewsItem(title: "Earnings call: ANI Pharmaceuticals sees robust growth in Q4 2023", image_url: "https://i-invdn-com.investing.com/news/LYNXMPEB0E0CQ_M.jpg", link: "https://au.investing.com/news/stock-market-news/earnings-call-ani-pharmaceuticals-sees-robust-growth-in-q4-2023-93CH-3138947"),
        NewsItem(title: "Mallinckrodt Announces U.S. FDA Approval of Supplemental New Drug Application for Acthar® Gel (repository corticotropin injection) Single-Dose Pre-filled SelfJect™ Injector", image_url: "https://mma.prnewswire.com/media/167103/mallinckrodt_plc_logo.jpg", link: "https://www.benzinga.com/pressreleases/24/03/n37420363/mallinckrodt-announces-u-s-fda-approval-of-supplemental-new-drug-application-for-acthar-gel-reposi")
    ]
    
    var body: some View {
        NewsCarouselView(newsItems: newsItems)
    }
}


import SwiftUI

struct final: View {
    @State private var newsItems = [NewsItem]()
    
    var body: some View {
        VStack {
            if newsItems.isEmpty {
                ProgressView()
            } else {
                NewsCarouselView(newsItems: newsItems)
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "https://newsdata.io/api/1/news?apikey=pub_393127e77b420771bfc9eff1a522c17d8e597&q=healthy%20diet&language=en") else {
                    print("Invalid URL")
                    return
                }
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error fetching data: \(error)")
                        return
                    }
                
                    
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                            
                            DispatchQueue.main.async {
                                // Update newsItems with decoded data
                                self.newsItems = response.results
                            }
                        } catch {
                            print("Error decoding data: \(error)")
                        }
                    }
                }.resume()
            }
        }

struct Final_Previews: PreviewProvider {
    static var previews: some View {
        //newsAPITest()
        final()
    }
}
