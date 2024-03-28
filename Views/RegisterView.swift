import SwiftUI

struct RegisterView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var nom = ""
    @State private var prenom = ""
    @State private var tshirt = "S" // Default size
    @State private var vegan = false
    @State private var hebergement = "oui" // Default option
    @State private var association = ""
    
    @State private var showAlert = false
    @EnvironmentObject var appState : AppState
    
    let tshirtSizes = ["S", "M", "L", "XL"] // Available t-shirt sizes
    let hebergementOptions = ["oui", "non"] // Available accommodation options
    
    var body: some View {
        ScrollView{
        VStack {
            Text("**Inscription**")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(.bottom,20)
            VStack(alignment: .leading, spacing: 8) {
                Text("**Username:**")
                TextField("", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("**Password:**")
                SecureField("", text: $password)
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
            
            Button("**S'inscrire**") {
                // Send the registration request
                sendRegistrationRequest()
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
                message: Text("Pseudo ou email existe deja."),
                dismissButton: .default(Text("Reessayer"))
            )
        }
        }
    }
    
    func sendRegistrationRequest() {
        // Create a dictionary with the form data
        let formData = [
            "username": username,
            "password": password,
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
        
        // Create the URL for the registration endpoint
        guard let url = URL(string: "https://awi-back.onrender.com/auth/signup") else {
            print("Invalid URL")
            return
        }
        
        // Create the URLRequest with the URL and HTTP method POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
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
                    // Registration successful
                    print("Registration successful")
                    appState.navigate(to: .login)
                case 409:
                    // Unauthorized - username or email already taken
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                default:
                    print("Unexpected response code:", httpResponse.statusCode)
                }
            }
            
            // Handle the response data
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response:", responseString)
                }
            }
        }.resume()
    }
}
