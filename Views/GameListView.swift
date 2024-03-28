import SwiftUI

struct GameListView: View {
    @State private var games: [GameInfo] = []
    @State private var searchText = ""
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(.horizontal)
                .padding(.top, 10)
            if games.isEmpty{
                Text("Pas de jeux encore...")
                    .padding(.top, 100)
            }
            List(filteredGames(searchText: searchText), id: \.jeu_id) { game in
                NavigationLink(destination: GameDetailView(game: game)) {
                    GameRow(game: game)
                }
            }
        }
        .onAppear {
            fetchGames()
        }
    }
    
    func fetchGames() {
        guard var urlComponents = URLComponents(string: "https://awi-back.onrender.com/file/jeux") else {
            print("Invalid URL")
            return
        }
        
        // Add festival_id query parameter
        let festivalIdQueryItem = URLQueryItem(name: "festival_id", value: "\(appState.festival_id)")
        urlComponents.queryItems = [festivalIdQueryItem]
        
        guard let url = urlComponents.url else {
            print("Invalid URL components")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([GameInfo].self, from: data)
                DispatchQueue.main.async {
                    self.games = decodedData
                }
            } catch {
                DispatchQueue.main.async {
                    self.games = []
                }
            }
        }.resume()
        
    }
    
    func filteredGames(searchText: String) -> [GameInfo] {
        if searchText.isEmpty {
            return games
        } else {
            return games.filter { game in
                game.nom_du_jeu.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct GameRow: View {
    let game: GameInfo
    
    var body: some View {
        HStack(spacing: 15) {
            if !game.image_jeu.isEmpty {
                AsyncImage(url: URL(string: game.image_jeu)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(game.nom_du_jeu)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Auteur: \(game.auteur)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Editeur: \(game.editeur)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 5)
        }
        .padding(.vertical, 10)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .opacity(text == "" ? 0 : 1)
            }
            .padding(.trailing, 8)
            //.padding(.leading, -8)
        }
    }
}
