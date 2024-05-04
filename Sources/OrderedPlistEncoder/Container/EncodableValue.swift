import Foundation

/// A wrapper that lets us special-case Data and Date in order to avoid encoding
/// them as arrays or numbers, respectively.
enum EncodableValue {
    case general(any Encodable)
    case data(Data)
    case date(Date)
}

extension EncodableValue {
    init(_ value: any Encodable) {
        switch value {
        case let value as Data:
            self = .data(value)
        case let value as Date:
            self = .date(value)
        default:
            self = .general(value)
        }
    }
}

extension EncodableValue: Encodable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .data(let value):
            try container.encode(value)
        case .date(let value):
            try container.encode(value)
        case .general(let value):
            try container.encode(value)
        }
    }
}
