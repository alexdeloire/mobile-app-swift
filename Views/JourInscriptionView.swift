import SwiftUI

struct JourBoxView: View {
    @EnvironmentObject var appState : AppState
    let jour: String
    let inscriptions: [InscriptionPoste]
    let zoneBenevoleInscriptions: [InscriptionZoneBenevole]
    var par_creneau: [String: String]{
        var creneauDict: [String: String] = [:]
        for inscription in inscriptions {
            if inscription.jour == jour {
                if inscription.is_register {
                    if creneauDict[inscription.creneau] != nil {
                        if creneauDict[inscription.creneau]!.contains("Aucune inscription") {
                            creneauDict[inscription.creneau] = inscription.poste
                        }
                        else {
                            creneauDict[inscription.creneau]! += ", " + inscription.poste
                        }
                    } else {
                        creneauDict[inscription.creneau] = inscription.poste
                    }
                } else {
                    if creneauDict[inscription.creneau] == nil {
                        creneauDict[inscription.creneau] = "Aucune inscription"
                    }
                }
            }
        }
        // loop to print just to check
        //for (key, value) in creneauDict {
        //   print("\(key) : \(value)")
        // }
        return creneauDict
    }
    var par_creneau_sorted: [String]{
        return par_creneau.keys.sorted(by: {c1, c2 in 
            if c1.count != c2.count{
                return c1.count < c2.count
            }
            return c1 < c2
        })
    }
    init(jour: String, inscriptions: [InscriptionPoste], zoneBenevoleInscriptions: [InscriptionZoneBenevole]) {
        self.jour = jour
        self.inscriptions = inscriptions
        self.zoneBenevoleInscriptions = zoneBenevoleInscriptions
        // self._par_creneau = State(initialValue: creneauDict)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(jour)
                .font(.title)
                .padding(.bottom)
            ForEach(par_creneau_sorted, id: \.self) { creneau in
                // Use appState to navigate to the next view
                Button(action: {
                    appState.navigate1(to: .creneauPoste(jour, creneau, inscriptions.filter { $0.jour == jour && $0.creneau == creneau }, zoneBenevoleInscriptions.filter { $0.jour == jour && $0.creneau == creneau }))
                }) {
                    HStack (spacing: 0){
                    Text("\(creneau)")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 70)
                    Spacer()
                    Text("\(par_creneau[creneau] ?? "Aucune inscription")")
                            //.padding(.right, 20)
                            .foregroundColor(.black)
                            .frame(minWidth: 180)
                            
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                (par_creneau[creneau] == "Aucune inscription") ? Color.red.opacity(0.8) : 
                                Color.green.opacity(0.8))
                            .shadow(color : .gray, radius: 2, x: 0, y: 3)
                    )
                }
                .padding(.bottom, 6)

                
                // NavigationLink(destination: CreneauPostesView(jour: jour, creneau: creneau, inscriptions: inscriptions.filter { $0.jour == jour && $0.creneau == creneau }, zoneBenevoleInscriptions: zoneBenevoleInscriptions.filter { $0.jour == jour && $0.creneau == creneau })) {
                //     Text("\(creneau) : \(par_creneau[creneau] ?? "Aucune inscription")")
                // }
            }
        }.onAppear{
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle("Inscriptions")

    }
}

struct InscriptionMainView: View {
    @EnvironmentObject var appState: AppState
    @State var dataByDayPoste: [String: [InscriptionPoste]] = [:]
    @State var dataByDayZoneBenevole: [String: [InscriptionZoneBenevole]] = [:]
    @State var showSuccessMessage = false
    
    var days: [String] {
        dataByDayPoste.keys.sorted(by: >)
    }
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    if dataByDayPoste.isEmpty{
                        //Text("Chargement...")
                            //.padding()
                        ActivityIndicator()
                            .frame(width: 100)
                            .padding(.top, 200)
                    }
                    if showSuccessMessage {
                        Text("Vous vous êtes inscrit avec succès")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .transition(.move(edge: .top))
                    }
                    ForEach(days, id: \.self) { day in
                        JourBoxView(jour: day, inscriptions: dataByDayPoste[day] ?? [], zoneBenevoleInscriptions: dataByDayZoneBenevole[day] ?? [])
                    }
                }
            }
        }
        .onAppear {
            fetchPosteInscriptions()
            fetchZoneBenevoleInscriptions()
            
            // Check if user has successfully registered
            if appState.hasInscribed == "success" {
                showSuccessMessage = true
                
                // Reset appState.hasInscribed
                appState.hasInscribed = ""
            }
            else{
                showSuccessMessage = false
            }
        }
    }
    
    func fetchPosteInscriptions() {
        guard var urlComponents = URLComponents(string: "https://awi-back.onrender.com/inscription/poste") else {
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
                let decodedData = try JSONDecoder().decode([InscriptionPoste].self, from: data)
                DispatchQueue.main.async {
                    self.dataByDayPoste = Dictionary(grouping: decodedData, by: { $0.jour })
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchZoneBenevoleInscriptions() {
        guard var urlComponents = URLComponents(string: "https://awi-back.onrender.com/inscription/zone-benevole") else {
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
                let decodedData = try JSONDecoder().decode([InscriptionZoneBenevole].self, from: data)
                DispatchQueue.main.async {
                    self.dataByDayZoneBenevole = Dictionary(grouping: decodedData, by: { $0.jour })
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
