//
//  PlaygroundContentView.swift
//  CupcakeCorner
//
//  Created by Bogdan Orzea on 2022-09-19.
//

import SwiftUI

struct PlaygroundContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
                .frame(width: 200, height: 200)
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("There was an error loading the image.")
                } else {
                    ProgressView()
                }
            }
                .frame(width: 200, height: 200)
            List(results, id: \.trackName) { item in
                VStack(alignment: .leading) {
                    Text(item.trackName)
                        .font(.headline)
                    Text(item.collectionName)
                }
            }.task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entry=song&limit=10") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(Reponse.self, from: data)
            
            results = decodedResponse.results
        } catch {
            print("Invalid data")
            print(error)
        }
    }
}

struct PlaygroundContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundContentView()
    }
}
