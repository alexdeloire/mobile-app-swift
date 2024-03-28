import SwiftUI

struct Message: Codable, Equatable, Hashable {
    let message_id: Int
    let festival_id: Int
    let user_to: Int
    let user_from: Int
    let user_from_username: String
    let user_from_role: String
    let msg: String
    let msg_date: String
    let is_read: Bool
    let is_active: Bool
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.message_id == rhs.message_id &&
        lhs.festival_id == rhs.festival_id &&
        lhs.user_to == rhs.user_to &&
        lhs.user_from == rhs.user_from &&
        lhs.user_from_username == rhs.user_from_username &&
        lhs.user_from_role == rhs.user_from_role &&
        lhs.msg == rhs.msg &&
        lhs.msg_date == rhs.msg_date &&
        lhs.is_read == rhs.is_read &&
        lhs.is_active == rhs.is_active
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(message_id)
        hasher.combine(festival_id)
        hasher.combine(user_to)
        hasher.combine(user_from)
        hasher.combine(user_from_username)
        hasher.combine(user_from_role)
        hasher.combine(msg)
        hasher.combine(msg_date)
        hasher.combine(is_read)
        hasher.combine(is_active)
    }
}
