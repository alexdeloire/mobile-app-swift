import SwiftUI

struct ExpressInscriptionPoste: Codable {
    let festival_id: Int
    let jour: String
    let creneau: String
    let inscriptions: [NewInscriptionPoste]
}
