import SwiftUI

struct InscriptionZoneBenevole: Codable, Equatable, Hashable {
    let festival_id: Int
    let poste: String
    let zone_plan: String
    let zone_benevole_id: String
    let zone_benevole_name: String
    let jour: String
    let creneau: String
    var nb_inscriptions: Int
    var is_register: Bool
    let max_capacity: Int
    
    static func == (lhs: InscriptionZoneBenevole, rhs: InscriptionZoneBenevole) -> Bool {
        return lhs.festival_id == rhs.festival_id &&
        lhs.poste == rhs.poste &&
        lhs.zone_plan == rhs.zone_plan &&
        lhs.zone_benevole_id == rhs.zone_benevole_id &&
        lhs.zone_benevole_name == rhs.zone_benevole_name &&
        lhs.jour == rhs.jour &&
        lhs.creneau == rhs.creneau &&
        lhs.nb_inscriptions == rhs.nb_inscriptions &&
        lhs.is_register == rhs.is_register &&
        lhs.max_capacity == rhs.max_capacity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(festival_id)
        hasher.combine(poste)
        hasher.combine(zone_plan)
        hasher.combine(zone_benevole_id)
        hasher.combine(zone_benevole_name)
        hasher.combine(jour)
        hasher.combine(creneau)
        hasher.combine(nb_inscriptions)
        hasher.combine(is_register)
        hasher.combine(max_capacity)
    }
}
