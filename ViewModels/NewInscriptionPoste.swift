import SwiftUI

struct NewInscriptionPoste: Codable, Equatable, Hashable {
    let festival_id: Int
    let poste: String
    let jour: String
    let creneau: String
    
    static func == (lhs: NewInscriptionPoste, rhs: NewInscriptionPoste) -> Bool {
        return lhs.festival_id == rhs.festival_id &&
        lhs.poste == rhs.poste &&
        lhs.jour == rhs.jour &&
        lhs.creneau == rhs.creneau
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(festival_id)
        hasher.combine(poste)
        hasher.combine(jour)
        hasher.combine(creneau)
    }
}
