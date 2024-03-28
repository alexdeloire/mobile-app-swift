import SwiftUI

struct ProfileView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var nom = ""
    @State private var prenom = ""
    @State private var tshirt = "S" // Default size
    @State private var vegan = false
    @State private var hebergement = "oui" // Default option
    @State private var association = ""
    
    @State private var showAlert = false
    @State private var showSuccessMessage = false
    @EnvironmentObject var appState : AppState
    
    let tshirtSizes = ["S", "M", "L", "XL"] // Available t-shirt sizes
    let hebergementOptions = ["oui", "non"] // Available accommodation options
    
    var body: some View {
        ScrollView{
            VStack {
                Text("**Profil**")
                    .font(.title)
                    .padding(.bottom,20)
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Username:** \(username)")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Email:**")
                    TextField("", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Telephone:**")
                    TextField("", text: $telephone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Nom:**")
                    TextField("", text: $nom)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Prenom:**")
                    TextField("", text: $prenom)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Taille T-shirt:**")
                    Picker("", selection: $tshirt) {
                        ForEach(tshirtSizes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("**Etes vous vegan?**", isOn: $vegan)
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Cherchez vous un hebergement?**")
                    Picker("", selection: $hebergement) {
                        ForEach(hebergementOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("**Association:**")
                    TextField("", text: $association)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                if showSuccessMessage {
                    Text("Profil mis à jour avec succès!")
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }
                Button("**Modifier**") {
                    // Send the profile update request
                    sendProfileUpdateRequest()
                }
                .padding(.vertical,10)
                .padding(.horizontal,10)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(15)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Attention"),
                    message: Text("Une erreur s'est produite lors de la mise Ã  jour du profil."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear{
            showSuccessMessage = false
            fetchUserData()
        }
    }
    
    func fetchUserData() {
        // Create the URL for fetching user data
        guard let url = URL(string: "https://awi-back.onrender.com/users/my-info") else {
            print("Invalid URL")
            return
        }
        
        // Create the URLRequest with the URL
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                print("Error:", error)
                return
            }
            
            // Check the HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response code")
                print("\(response!)")
                return
            }
            
            // Parse the JSON data
            if let data = data {
                do {
                    let userData = try JSONDecoder().decode(User.self, from: data)
                    DispatchQueue.main.async {
                        self.username = userData.username
                        self.email = userData.email
                        self.telephone = userData.telephone
                        self.nom = userData.nom
                        self.prenom = userData.prenom
                        self.tshirt = userData.tshirt
                        self.vegan = userData.vegan
                        self.hebergement = userData.hebergement
                        self.association = userData.association
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            }
        }.resume()
    }
    
    func sendProfileUpdateRequest() {
        // Create a dictionary with the form data
        let formData = [
            "username": username,
            "email": email,
            "telephone": telephone,
            "nom": nom,
            "prenom": prenom,
            "tshirt": tshirt,
            "vegan": vegan,
            "hebergement": hebergement,
            "association": association
        ] as [String : Any]
        
        // Convert the form data into JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: formData) else {
            print("Error encoding form data")
            return
        }
        
        // Create the URL for the profile update endpoint
        guard let url = URL(string: "https://awi-back.onrender.com/users/update-info") else {
            print("Invalid URL")
            return
        }
        
        // Create the URLRequest with the URL and HTTP method PUT 
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        
        // Set the request body with the JSON data
        request.httpBody = jsonData
        
        // Set the Content-Type header to application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                print("Error:", error)
                return
            }
            
            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200..<300:
                    // Profile update successful
                    print("Profile update successful")
                    // You may want to handle success accordingly, such as showing a success message
                    DispatchQueue.main.async {
                        showSuccessMessage = true
                    }
                default:
                    print("Unexpected response code:", httpResponse.statusCode)
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                }
            }
        }.resume()
    }
}


