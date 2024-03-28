import SwiftUI

struct MessageReplyView: View {
    @State private var replyMessage: String = ""
    
    @EnvironmentObject var appState: AppState
    let message: Message
    
    var body: some View {
        VStack {
            Text("Répondre à \(message.user_from_username)")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            TextField("Votre message", text: $replyMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: sendMessage) {
                Text("Envoyer")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    private func sendMessage() {
        guard let url = URL(string: "https://awi-back.onrender.com/message/send") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "festival_id": message.festival_id,
            "user_to": message.user_from,
            "message": replyMessage
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to encode JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                // Handle error
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                print("Message sent successfully")
                DispatchQueue.main.async {
                    appState.navigateToRootMessage()
                }
            } else {
                print("Error: Invalid response")
            }
        }.resume()
    }
}
