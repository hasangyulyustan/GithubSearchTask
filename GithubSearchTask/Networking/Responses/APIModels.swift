import Foundation

// MARK: - extension Decodable -

extension Decodable {

    init(data: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

}

// MARK: - ErrorModel -

struct ErrorModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case failures = "failures"
    }

    let message: String
    var code: Int? = nil
    let failures: [Failure]?
}

struct Failure: Decodable {

    enum CodingKeys: String, CodingKey {
        case key = "key"
        case message = "message"
    }

    let key: String
    let message: String
    var keyID:Int? = nil

    init(key:String,message:String) {
        self.key = key
        self.message = message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        message = try container.decode(String.self, forKey: .message)
        if let number = Int(key.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
            keyID = number
        }
    }
}
