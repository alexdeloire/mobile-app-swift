import SwiftUI

struct CreneauZoneBenevoleView: View {
    private var newInscriptionsPoste: [NewInscriptionPoste]
    @State private var zoneBenevoleInscriptions : [InscriptionZoneBenevole]
    @State private var selectedInscriptionIndex: Int?
    
    let day: String
    let creneau: String
    
    @EnvironmentObject var appState: AppState
    
    init(jour: String, creneau: String, inscriptions: [InscriptionZoneBenevole], newInscriptionsPoste: [NewInscriptionPoste]) {
        let inscriptionsTri = inscriptions.sorted(by: {c1, c2 in return c1.zone_plan < c2.zone_plan})
        self.zoneBenevoleInscriptions = inscriptionsTri
        self.newInscriptionsPoste = newInscriptionsPoste
        self.day = jour
        self.creneau = creneau
        // Find the index of the inscription that is already registered
        if let index = inscriptions.firstIndex(where: { $0.is_register }) {
            self._selectedInscriptionIndex = State(initialValue: index)
        }
    }
    
    var body: some View {
        VStack {
            Text("\(day) - \(creneau)")
                .font(.title)
                .padding()
            Text("Veuillez choisir une zone pour le poste Animation.")
            ScrollView {
                VStack(spacing: 20) {
                    Button(action: {
                        // Save changes
                        savePosteInscriptions()
                        saveZoneBenevoleInscriptions()
                        appState.hasInscribed = "success"
                        appState.navigateToRoot1()
                    }) {
                        Text("Enregistrer")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    ForEach(zoneBenevoleInscriptions.indices, id: \.self) { index in
                        ZoneBenevoleBoxView(inscription: self.$zoneBenevoleInscriptions[index], selectedInscriptionIndex: $selectedInscriptionIndex, index: index)
                            .onChange(of: selectedInscriptionIndex) {
                                updateInscriptions()
                            }
                    }
                }
                .padding()
            }
        }
    }
    
    func savePosteInscriptions() {
        
        // Create an ExpressInscriptionPoste object to send to the server
        let expressInscription = ExpressInscriptionPoste(festival_id: appState.festival_id, jour: day, creneau: creneau, inscriptions: newInscriptionsPoste)
        
        // Make a POST request to the server
        guard let encoded = try? JSONEncoder().encode(expressInscription) else {
            print("Failed to encode expressInscription")
            return
        }
        let url = URL(string: "https://awi-back.onrender.com/inscription/poste/express-inscription")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if the request was successful 200
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Inscriptions POSTES saved")
                }
                else {
                    print("Failed to save inscriptions: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func saveZoneBenevoleInscriptions() {
        // Create a list of inscriptions to send to the server where is_register is true
        let inscriptionsToSave = zoneBenevoleInscriptions.filter { $0.is_register }
        var newInscriptions: [NewInscriptionZoneBenevole] = []
        for inscription in inscriptionsToSave {
            newInscriptions.append(NewInscriptionZoneBenevole(festival_id: inscription.festival_id, poste: inscription.poste, zone_plan: inscription.zone_plan, zone_benevole_id: inscription.zone_benevole_id, zone_benevole_name: inscription.zone_benevole_name, jour: inscription.jour, creneau: inscription.creneau))
        }
        // Create an ExpressInscriptionPoste object to send to the server
        let expressInscription = ExpressInscriptionZoneBenevole(festival_id: appState.festival_id, jour: day, creneau: creneau, inscriptions: newInscriptions)
        
        // Make a POST request to the server
        guard let encoded = try? JSONEncoder().encode(expressInscription) else {
            print("Failed to encode expressInscription")
            return
        }
        let url = URL(string: "https://awi-back.onrender.com/inscription/zone-benevole/express-inscription")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if the request was successful 200
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Inscriptions ZONES saved")
                }
                else {
                    print("Failed to save inscriptions: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func updateInscriptions() {
        guard let selectedIndex = selectedInscriptionIndex else {
            return // No inscription is selected
        }
        // Deselect all inscriptions except the selected one
        for index in zoneBenevoleInscriptions.indices {
            if index != selectedIndex {
                if zoneBenevoleInscriptions[index].is_register {
                    zoneBenevoleInscriptions[index].nb_inscriptions -= 1
                }
                zoneBenevoleInscriptions[index].is_register = false
            }
        }
    }
    
    
}


struct ZoneBenevoleBoxView: View {
    @Binding var inscription: InscriptionZoneBenevole
    @Binding var selectedInscriptionIndex: Int?
    let index: Int
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        
        let isSelected : Bool
        if let selectedInscriptionIndex = selectedInscriptionIndex {
            isSelected = selectedInscriptionIndex == index
        } else {
            isSelected = false
        }
        let color = isSelected ? Color.green : Color.red
        let textColor = isSelected ? Color.white : Color.black
        let bgColor = isSelected ? Color.gray.opacity(0.15) : Color.gray.opacity(0.4)
        
        return  Button(action: {
            if isSelected {
                selectedInscriptionIndex = nil // Deselect if already selected
            } else {
                selectedInscriptionIndex = index // Select this inscription
            }
            if inscription.is_register {
                inscription.nb_inscriptions -= 1
            }
            else{
                inscription.nb_inscriptions += 1
            }
            inscription.is_register.toggle()
        }) {
            HStack(spacing : 10) {
                VStack {
                    HStack (alignment: .center, spacing: 10) {
                        // The text is zone_benevole_name if not empty, otherwise zone_plan
                        Text(inscription.zone_benevole_name.isEmpty ? inscription.zone_plan : inscription.zone_benevole_name)
                            .font(.headline)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(5)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .foregroundColor(color)
                        Spacer()
                        Text("\(inscription.nb_inscriptions) / \(inscription.max_capacity)")
                            .font(.headline)
                            .foregroundColor(color)
                            .padding(.vertical, 5)
                            .frame(width: 50)
                        Spacer()
                        
                    }
                    Rectangle()
                        .fill(color)
                        .frame(height: 5)
                        .cornerRadius(4)
                }
                Button(action: {appState.navigate1(to: .creneauGame(inscription))}){
                    Text("Voir jeux")
                }                
                .padding(10)
                .background(color)
                .foregroundColor(textColor)
                .cornerRadius(12)
            }
            .padding(10)
            //.background(Color.gray.opacity(0.1))
            //.cornerRadius(10)
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(bgColor)
                    .shadow(color : .gray, radius: 2, x: 0, y: 3)
            )
        }
        
    }
    
    
}
