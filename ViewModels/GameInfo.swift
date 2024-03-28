import SwiftUI

struct GameInfo: Codable, Identifiable {
    let festival_id: Int
    let jeu_id: Int
    let nom_du_jeu: String
    let auteur: String
    let editeur: String
    let nb_joueurs: String
    let age_min: String
    let duree: String
    let type_jeu: String
    let notice: String
    let zone_plan: String
    let zone_benevole: String
    let zone_benevole_id: String
    let a_animer: String
    let recu: String
    let mecanismes: String
    let themes: String
    let tags: String
    let description: String
    let image_jeu: String
    let logo: String
    let video: String
    
    var id: Int{
        return jeu_id
    }
}
