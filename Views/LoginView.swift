import SwiftUI

struct LoginResponseModel : Codable{
    let user_id: Int
    let username: String
    let roles: [String]
    let access_token: String
    let token_type: String
}

struct FestivalResponse: Decodable {
    let festival_id: Int
    let festival_name: String
    let festival_description: String
    let is_active: Bool
}

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        VStack {
            Text("**Connexion**")
                .font(.title)
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
            
            Button("**Login**") {
                login()
            }
            .padding(.vertical,10)
            .padding(.horizontal,15)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(15)
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
    
    func login() {
        
        guard !username.isEmpty else {
            alertMessage = "Username is required"
            showAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Password is required"
            showAlert = true
            return
        }
        
        // Create a dictionary to represent the form data
        let formData = [
            "grant_type": "",
            "username": username,
            "password": password,
            "scope": "",
            "client_id": "",
            "client_secret": ""
        ]
        
        // Convert the form data into a query string
        let formDataString = formData.map { (key, value) in
            return "\(key)=\(value)"
        }.joined(separator: "&")
        
        // Create the URL for your backend endpoint
        let url = URL(string: "https://awi-back.onrender.com/auth/token")!
        
        // Create the URLRequest with the URL and HTTP method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the Content-Type header to application/x-www-form-urlencoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Set the HTTP body with the form data string
        request.httpBody = formDataString.data(using: .utf8)
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    alertMessage = "Invalid server response"
                    showAlert = true
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(LoginResponseModel.self, from: data)
                        DispatchQueue.main.async {
                            appState.user_id = response.user_id
                            appState.username = response.username
                            appState.access_token = response.access_token
                            appState.roles = response.roles
                            appState.token_type = response.token_type
                            
                            fetchActiveFestival()
                            
                        }
                        appState.navigateBack()
                    } catch {
                        DispatchQueue.main.async {
                            alertMessage = "Failed to decode response"
                            showAlert = true
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    alertMessage = "Username ou mot de passe incorrect"
                    showAlert = true
                }
            }
            
        }.resume()
    }
    
    func fetchActiveFestival() {
        guard let url = URL(string: "https://awi-back.onrender.com/festival/active") else {
            print("Invalid URL")
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
                let decodedData = try JSONDecoder().decode(FestivalResponse.self, from: data)
                appState.festival_id = decodedData.festival_id
                // print("Festival ID: \(appState.festival_id)")
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
}
