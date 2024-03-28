import SwiftUI

struct CreneauPostesView: View {
    @State private var inscriptions: [InscriptionPoste]
    let zoneBenevoleInscriptions: [InscriptionZoneBenevole]
    let day: String
    let creneau: String
    
    var nb_register: Int {
        return inscriptions.filter { $0.is_register }.count
    }
    
    @EnvironmentObject var appState: AppState
    
    init(jour: String, creneau: String, inscriptions: [InscriptionPoste], zoneBenevoleInscriptions: [InscriptionZoneBenevole]) {
        self.inscriptions = inscriptions
        self.zoneBenevoleInscriptions = zoneBenevoleInscriptions
        // All inscriptions have the same day and creneau
        self.day = jour
        self.creneau = creneau
    }
    
    var body: some View {
        VStack {
            Text("\(day) - \(creneau)")
                .font(.title)
                .padding()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack{
                        if nb_register > 1 {
                            Text("Attention, vous êtes flexibles, l'admin choisira pour vous")
                                .font(.headline)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(16)
                        }
                        Button(action: {
                            // If the csv hasn't been uploaded or he hasn't selected Animation Poste, save the inscriptions
                            if zoneBenevoleInscriptions.isEmpty || inscriptions.filter({ $0.poste == "Animation" }).first?.is_register == false {
                                // Save changes
                                saveInscriptions()
                                appState.hasInscribed = "success"
                                appState.navigateBack1()
                            }
                            else{
                                // Create a list of inscriptions to send to the server where is_register is true
                                let inscriptionsToSave = inscriptions.filter { $0.is_register }
                                var newInscriptions: [NewInscriptionPoste] = []
                                for inscription in inscriptionsToSave {
                                    newInscriptions.append(NewInscriptionPoste(festival_id: inscription.festival_id, poste: inscription.poste, jour: inscription.jour, creneau: inscription.creneau))
                                }
                                appState.navigate1(to: .creneauZone(day, creneau, zoneBenevoleInscriptions, newInscriptions))
                            }
                        }) {
                            Text("Enregistrer")
                                .font(.headline)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.blue.opacity(0.8))
                                        .shadow(color : .gray, radius: 2, x: 0, y: 3)
                                )
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height:100)
                    ForEach(inscriptions.indices, id: \.self) { index in
                        PosteBoxView(inscription: self.$inscriptions[index])
                    }
                }
                .padding()
            }
        }
    }
    
    func saveInscriptions() {
        // Create a list of inscriptions to send to the server where is_register is true
        let inscriptionsToSave = inscriptions.filter { $0.is_register }
        var newInscriptions: [NewInscriptionPoste] = []
        for inscription in inscriptionsToSave {
            newInscriptions.append(NewInscriptionPoste(festival_id: inscription.festival_id, poste: inscription.poste, jour: inscription.jour, creneau: inscription.creneau))
        }
        // Create an ExpressInscriptionPoste object to send to the server
        let expressInscription = ExpressInscriptionPoste(festival_id: appState.festival_id, jour: day, creneau: creneau, inscriptions: newInscriptions)
        
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
}


struct PosteBoxView: View {
    @Binding var inscription: InscriptionPoste
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        let color = inscription.is_register ? Color.green.opacity(0.8) : Color.red.opacity(0.8)
        let textColor = inscription.is_register ? Color.white : Color.black
        let bgColor = inscription.is_register ? Color.gray.opacity(0.15) : Color.gray.opacity(0.4)
        // let ratio = CGFloat(inscription.nb_inscriptions) / CGFloat(inscription.max_capacity)
        
        return Button(action: {
            if inscription.is_register {
                inscription.nb_inscriptions -= 1
            }
            else{
                inscription.nb_inscriptions += 1
            }
            inscription.is_register.toggle()
        }) {
            HStack (spacing: 10){
                VStack {
                    HStack (alignment: .center, spacing: 10){
                        Text(inscription.poste)
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
                    //.frame(maxWidth: .infinity * ratio)
                }
                Button(action: {appState.navigate1(to: .posteDetail(inscription))}){
                    Text("Voir plus")
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





