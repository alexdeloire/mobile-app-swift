import SwiftUI

struct InscriptionPoste: Codable, Equatable, Hashable {
    let festival_id: Int
    let poste: String
    let jour: String
    let creneau: String
    var nb_inscriptions: Int
    var is_register: Bool
    let max_capacity: Int
    
    static func == (lhs: InscriptionPoste, rhs: InscriptionPoste) -> Bool {
        return lhs.festival_id == rhs.festival_id &&
        lhs.poste == rhs.poste &&
        lhs.jour == rhs.jour &&
        lhs.creneau == rhs.creneau &&
        lhs.nb_inscriptions == rhs.nb_inscriptions &&
        lhs.is_register == rhs.is_register &&
        lhs.max_capacity == rhs.max_capacity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(festival_id)
        hasher.combine(poste)
        hasher.combine(jour)
        hasher.combine(creneau)
        hasher.combine(nb_inscriptions)
        hasher.combine(is_register)
        hasher.combine(max_capacity)
    }
    
}
