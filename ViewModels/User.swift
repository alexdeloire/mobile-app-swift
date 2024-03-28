import SwiftUI

struct User: Codable {
    var user_id: Int
    var username: String
    var email: String
    var telephone: String
    var nom: String
    var prenom: String
    var tshirt: String
    var vegan: Bool
    var hebergement: String
    var association: String
    var roles: [String]
    var disabled: Bool
}
