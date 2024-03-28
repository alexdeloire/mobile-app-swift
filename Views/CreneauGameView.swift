import SwiftUI


struct CreneauGameView: View {
    
    @State private var gameInfos: [GameInfo] = []
    let inscription: InscriptionZoneBenevole
    
    var text_to_display : String{
        return inscription.zone_benevole_name.isEmpty ? inscription.zone_plan : inscription.zone_benevole_name
    }
    
    var zone_plan: String{
        return inscription.zone_plan
    }
    var zone_benevole_name: String{
        return inscription.zone_benevole_name
    }
    
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Jeux pour \(text_to_display)")
                .font(.title)
                .padding()
            
            if gameInfos.isEmpty {
                ProgressView("Fetching Games...")
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(gameInfos, id: \.jeu_id) { gameInfo in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(gameInfo.nom_du_jeu)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("By: \(gameInfo.auteur)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Published by: \(gameInfo.editeur)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Players: \(gameInfo.nb_joueurs)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Minimum Age: \(gameInfo.age_min)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Duration: \(gameInfo.duree)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Game Type: \(gameInfo.type_jeu)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Mechanisms: \(gameInfo.mecanismes)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Themes: \(gameInfo.themes)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Description: \(gameInfo.description)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(3)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchGameInfos()
        }
    }
    
    private func fetchGameInfos() {
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
                    // Filter the games for the selected zone
                    self.gameInfos = decodedData.filter { gameInfo in
                        return gameInfo.zone_plan == self.zone_plan && gameInfo.zone_benevole == self.zone_benevole_name
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
        
    }
}

