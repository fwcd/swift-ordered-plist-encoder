import Foundation

/// An encoder that encodes to an ordered XML property list.
public struct OrderedPlistEncoder {
    public init() {}

    /// Encodes a value to an ordered XML property list to UTF-8-encoded data.
    public func encode<Value>(_ value: Value) throws -> Data where Value: Encodable {
        guard let data = try encodeToString(value).data(using: .utf8) else {
            throw OrderedPlistEncodingError.couldNotConvertToUTF8
        }
        return data
    }

    /// Encodes a value to an ordered XML property list as `String`.
    public func encodeToString<Value>(_ value: Value) throws -> String where Value: Encodable {
        try encodeToXML(value).xmlString
    }

    /// Encodes a value to an ordered XML property list as `XMLElement`.
    public func encodeToXML<Value>(_ value: Value) throws -> XMLElement where Value: Encodable {
        let encoder = OrderedPlistEncoderImpl()
        try value.encode(to: encoder)
        return encoder.element
    }
}
