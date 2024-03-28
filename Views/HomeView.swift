import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .font(.system(size: 56))
                .foregroundColor(.accentColor)
            
            Text("**Festival du Jeu Montpellier**")
                .font(.system(size: 24))
            
            if appState.access_token.isEmpty {
                Button("**Se connecter**") {
                    appState.navigate(to: .login)
                }
                .padding(.top, 12)
                
                Button("**Créer un compte**") {
                    appState.navigate(to: .register)
                }
            } else {
                Button("**Déconnexion**") {
                    disconnect()
                }
                .foregroundColor(.red)
                .padding(.top, 12)
                
                Button("**RGPD**") {
                    appState.navigate(to: .rgpd)
                }
                .foregroundColor(.red)
                .padding(.top, 12)
            }
        }
        .padding()
    }
    
    // Function to handle logout
    func disconnect() {
        appState.clearState()
    }
}
