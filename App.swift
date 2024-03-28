import SwiftUI

@main
struct MyApp: App {
    
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack(path: $appState.navPath) {
                    HomeView()
                        .navigationDestination(for: AppState.Destination.self) { destination in
                            switch destination {
                            case .login:
                                LoginView()
                            case .register:
                                RegisterView()
                            case .rgpd:
                                RGPDView()
                            default:
                                EmptyView()
                            }
                        }
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                if !appState.access_token.isEmpty {
                    NavigationStack(path: $appState.navPathGame) {
                        GameListView()
                            .navigationDestination(for: AppState.Destination.self) { destination in
                                switch destination {
                                case .gameList:
                                    GameListView()
                                default:
                                    EmptyView()
                                }
                            }
                    }
                    .tabItem {
                        Label("Jeux", systemImage: "gamecontroller")
                    }
                    
                    NavigationStack(path: $appState.navPath1) {
                        InscriptionMainView()
                            .navigationDestination(for: AppState.Destination.self) { destination in
                                switch destination {
                                case .creneauPoste(let jour, let creneau, let inscriptionsPostes, let inscriptionsZones):
                                    CreneauPostesView(jour: jour, creneau: creneau, inscriptions: inscriptionsPostes, zoneBenevoleInscriptions: inscriptionsZones)
                                case .creneauZone(let jour, let creneau, let inscriptionsZones, let newInscriptions):
                                    CreneauZoneBenevoleView(jour: jour, creneau: creneau, inscriptions: inscriptionsZones, newInscriptionsPoste: newInscriptions)
                                case .creneauGame(let inscription):
                                    CreneauGameView(inscription: inscription)
                                case .posteDetail(let inscription):
                                    PosteDetailView(inscription: inscription)
                                default:
                                    EmptyView()
                                }
                            }
                    }
                    .tabItem {
                        Label("Inscription", systemImage: "square.and.pencil")
                    }
                    
                    NavigationStack(path: $appState.navPathMessage) {
                        MessageMainView()
                            .navigationDestination(for: AppState.Destination.self) { destination in
                                switch destination {
                                case .messageMain:
                                    MessageMainView()
                                case .messageReply(let message):
                                    MessageReplyView(message: message)
                                default:
                                    EmptyView()
                                }
                            }
                    }
                    .tabItem {
                        Label("Message", systemImage: "message")
                    }
                    
                    NavigationStack(path: $appState.navPathProfile) {
                        ProfileView()
                            .navigationDestination(for: AppState.Destination.self) { destination in
                                switch destination {
                                case .profile:
                                    ProfileView()
                                default:
                                    EmptyView()
                                }
                            }
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    
                }
            }
            .environmentObject(appState)
        }
    }
}
