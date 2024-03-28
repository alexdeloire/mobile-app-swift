import SwiftUI

struct RGPDView: View {
    @State private var pressedOnce: Bool = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Nous prenons la protection de vos données très au sérieux. Si vous souhaitez supprimer votre compte, veuillez noter que toutes vos données seront supprimées de manière permanente. Ceci est conforme à la réglementation RGPD.")
                .padding()
            
            if !pressedOnce {
                Button("Supprimer mon compte et toutes mes données") {
                    pressedOnce = true
                }
                .foregroundColor(.red)
                .padding()
            } else {
                Button("Appuyer encore une fois pour supprimer") {
                    //deleteAccountAndData()
                    appState.clearState()
                    appState.navigateToRoot()
                }
                .foregroundColor(.red)
                .padding()
            }
            
            Spacer()
        }
    }
    
    func deleteAccountAndData() {
        guard let urlComponents = URLComponents(string: "https://awi-back.onrender.com/users/delete-data") else {
            print("Invalid URL")
            return
        }
        
        guard let url = urlComponents.url else {
            print("Invalid URL components")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            
            
        }.resume()
    }
}
