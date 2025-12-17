enum NotificationTypeEnum: String, Codable {
    case reply
    case like
    case follow
    case unknown
}

extension NotificationTypeEnum {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = NotificationTypeEnum(rawValue: rawValue) ?? .unknown
    }
}

