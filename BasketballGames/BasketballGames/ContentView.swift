//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI
struct Response: Codable {
    var games: [Game]
}
struct Game: Codable {
    var team: String
    var date: String
    var opponent: String
    var isHomeGame: Bool
    var score: Score
    var id: Int
}
struct Score: Codable {
    var opponent: Int
    var unc: Int
}

struct ContentView: View {
    @State private var games = [Game]()
    
    var body: some View {
        NavigationStack{
            List(games, id: \.id){ item in
                
                let homeOrAway = item.isHomeGame == true ? "Home" : "Away"
                
                VStack(alignment: .leading){
                    HStack{
                        Text("\(item.team) vs. \(item.opponent)")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Spacer()
                        VStack{
                            Text("\(item.score.unc) - \(item.score.opponent)")
                        }
                    }
                    HStack{
                        Text(item.date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(homeOrAway)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .task{
                await loadData()
            }
            .navigationTitle(Text("UNC Basketball"))
        }
        
    }
    func loadData() async {
        guard let url = URL(string:
        "https://api.samuelshi.com/uncbasketball")
        else{
            print( "Invalid URL")
            return
        }
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try?
                JSONDecoder().decode([Game].self, from: data){
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
