import SwiftUI

struct MessageMainView: View {
    @State private var messages: [Message] = []
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if messages.isEmpty {
                //ProgressView("Fetching Messages...")
                Text("Pas de messages")
            } else {
                List(messages, id: \.message_id) { message in
                    MessageRowView(message: message, replyAction: reply, deleteAction: delete)
                }
            }
        }
        .navigationBarTitle("Messages")
        .navigationBarItems(trailing: Button(action: deleteAll) {
            Image(systemName: "trash.fill")
                .padding()
        })
        .onAppear {
            fetchMessages()
        }
    }
    
    private func fetchMessages() {
        
        guard let url = URL(string: "https://awi-back.onrender.com/message/\(appState.festival_id)") else {
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
                let decodedData = try JSONDecoder().decode([Message].self, from: data)
                DispatchQueue.main.async {
                    self.messages = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    private func reply(message: Message) {
        // Implement reply action for a specific message
        print("Reply to message \(message.message_id)")
    }
    
    private func delete(message: Message) {
        guard let url = URL(string: "https://awi-back.onrender.com/message") else {
            print("Invalid URL")
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "message_id", value: "\(message.message_id)")]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting message: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTP response")
                return
            }
            
            if (200..<300).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    self.messages.removeAll { $0.message_id == message.message_id }
                }
            } else {
                print("Failed to delete message: \(httpResponse.statusCode)")
            }
        }.resume()
    }
    
    
    private func deleteAll() {
        let url = URL(string: "https://awi-back.onrender.com/message/clear-all/\(appState.festival_id)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(appState.access_token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.messages.removeAll()
                    }
                } else {
                    print("Failed to delete messages: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}

struct MessageRowView: View {
    let message: Message
    
    let replyAction: (Message) -> Void
    let deleteAction: (Message) -> Void
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        
        return  Button(action: {
        }) {
            VStack(alignment: .leading, spacing: 5) {
                Text("From: \(message.user_from_username) (\(message.user_from_role))")
                    .font(.headline)
                Text("Message: \(message.msg)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Date: \(message.msg_date)")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack{
                    Button(action: {appState.navigateMessage(to: .messageReply(message))}){
                        Image(systemName: "arrowshape.turn.up.left")
                   }
                    Button(action: {deleteAction(message)}){
                        Image(systemName: "trash")
                    }
                }
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 5)
            }
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(.bottom, 10)
        
    }
    
}


