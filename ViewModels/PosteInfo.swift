import SwiftUI

struct PosteInfo: Codable{
    let user_ids: [Int]
    let usernames: [String]
    let poste_id: Int
    let poste: String
    let description_poste: String
    let max_capacity: Int
}
