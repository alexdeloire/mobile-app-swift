import SwiftUI


struct PosteDetailView: View {
    let inscription: InscriptionPoste
    @State private var posteInfo: PosteInfo = PosteInfo(user_ids: [], usernames: [], poste_id: 0, poste: "", description_poste: "", max_capacity: 0)
    
    @EnvironmentObject var appState: AppState
    
    init(inscription: InscriptionPoste) {
        self.inscription = inscription
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing : 10) {
                if posteInfo.poste_id == 0 {
                    ProgressView()
                }
                else{
                    VStack {
                        Text(posteInfo.poste)
                            .font(.headline)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.bottom, 10)
                        Text(posteInfo.description_poste)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                            .shadow(color : .gray, radius: 2, x: 0, y: 3)
                    )
                    VStack {
                        Text("Referents:")
                            .font(.title2)
                        if posteInfo.usernames.isEmpty {
                            Text("Pas de referents pour ce poste")
                        } else {
                            ForEach(posteInfo.usernames, id: \.self) { username in
                                Text(username)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.1))
                            .shadow(color : .gray, radius: 2, x: 0, y: 3)
                    )
                    
                }
            }
            .navigationTitle("Poste Details")
            .onAppear{
                loadPosteInfo()
            }
        }
    }
    
    func loadPosteInfo() {
        
        let url = URL(string: "https://awi-back.onrender.com/poste/\(appState.festival_id)/\(inscription.poste)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Check response status
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    print("Error: \(httpResponse.statusCode)")
                    // Print additional error information
                    if let dataString = String(data: data, encoding: .utf8) {
                        print(dataString)
                    }
                    return
                }
            }
            
            do {
                let decodedData = try JSONDecoder().decode([PosteInfo].self, from: data)
                DispatchQueue.main.async {
                    self.posteInfo = decodedData[0]
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

