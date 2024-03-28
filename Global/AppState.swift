import SwiftUI

final class AppState: ObservableObject {
    
    public enum Destination: Hashable {
        case login
        case register
        case profile
        case creneauPoste(String, String, [InscriptionPoste], [InscriptionZoneBenevole])
        case creneauZone(String, String, [InscriptionZoneBenevole], [NewInscriptionPoste])
        case creneauGame(InscriptionZoneBenevole)
        case messageMain
        case posteDetail(InscriptionPoste)
        case gameList
        case messageReply(Message)
        case rgpd
    }
    
    @Published var navPath = NavigationPath()
    @Published var navPath1 = NavigationPath()
    @Published var navPathProfile = NavigationPath()
    @Published var navPathMessage = NavigationPath()
    @Published var navPathGame = NavigationPath()
    
    @Published var user_id: Int = 0
    @Published var username: String = ""
    @Published var roles: [String] = []
    @Published var access_token: String = ""
    @Published var token_type: String = ""
    @Published var festival_id: Int = 0
    @Published var festival_name: String = ""
    @Published var festival_description: String = ""
    @Published var hasInscribed: String = ""
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
    
    func navigate1(to destination: Destination) {
        navPath1.append(destination)
    }
    
    func navigateBack1() {
        navPath1.removeLast()
    }
    
    func navigateToRoot1() {
        navPath1.removeLast(navPath1.count)
    }
    
    func navigateProfile(to destination: Destination) {
        navPathProfile.append(destination)
    }
    
    func navigateBackProfile() {
        navPathProfile.removeLast()
    }
    
    func navigateToRootProfile() {
        navPathProfile.removeLast(navPathProfile.count)
    }
    
    func navigateMessage(to destination: Destination) {
        navPathMessage.append(destination)
    }
    
    func navigateBackMessage() {
        navPathMessage.removeLast()
    }
    
    func navigateToRootMessage() {
        navPathMessage.removeLast(navPathMessage.count)
    }
    
    func navigateGame(to destination: Destination) {
        navPathGame.append(destination)
    }
    
    func navigateBackGame() {
        navPathGame.removeLast()
    }
    
    func navigateToRootGame() {
        navPathGame.removeLast(navPathGame.count)
    }
    
    func clearState() {
        self.user_id = 0
        self.username = ""
        self.roles = []
        self.festival_id = 0
        self.festival_name = ""
        self.festival_description = ""
        self.token_type = ""
        self.access_token = ""
        
    }
}
