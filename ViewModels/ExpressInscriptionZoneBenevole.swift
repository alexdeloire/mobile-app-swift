import SwiftUI

struct ExpressInscriptionZoneBenevole: Codable {
    let festival_id: Int
    let jour: String
    let creneau: String
    let inscriptions: [NewInscriptionZoneBenevole]
}
