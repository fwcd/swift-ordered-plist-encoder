import Foundation
#if canImport(FoundationXML)
import FoundatiomXML
#endif

struct SingleValueOrderedPlistEncodingContainer: SingleValueEncodingContainer {
    private let element: XMLElement
    private(set) var codingPath: [any CodingKey]

    init(element: XMLElement, codingPath: [any CodingKey]) {
        self.element = element
        self.codingPath = codingPath
    }

    private mutating func encodeInteger<Integer>(_ i: Integer) where Integer: LosslessStringConvertible {
        element.name = "integer"
        element.stringValue = String(i)
    }

    private mutating func encodeReal<Real>(_ x: Real) where Real: LosslessStringConvertible {
        element.name = "real"
        element.stringValue = String(x)
    }

    mutating func encodeNil() {
        encode("$null")
    }

    mutating func encode(_ value: Bool) {
        element.name = value ? "true" : "false"
        element.stringValue = nil
    }

    mutating func encode(_ value: String) {
        element.name = "string"
        element.stringValue = value
    }

    mutating func encode(_ value: Double) {
        encodeReal(value)
    }

    mutating func encode(_ value: Float) {
        encodeReal(value)
    }

    mutating func encode(_ value: Int) {
        encodeInteger(value)
    }

    mutating func encode(_ value: Int8) {
        encodeInteger(value)
    }

    mutating func encode(_ value: Int16) {
        encodeInteger(value)
    }

    mutating func encode(_ value: Int32) {
        encodeInteger(value)
    }

    mutating func encode(_ value: Int64) {
        encodeInteger(value)
    }

    mutating func encode(_ value: UInt) {
        encodeInteger(value)
    }

    mutating func encode(_ value: UInt8) {
        encodeInteger(value)
    }

    mutating func encode(_ value: UInt16) {
        encodeInteger(value)
    }

    mutating func encode(_ value: UInt32) {
        encodeInteger(value)
    }

    mutating func encode(_ value: UInt64) {
        encodeInteger(value)
    }

    mutating func encode<T>(_ value: T) throws where T: Encodable {
        let encoder = OrderedPlistEncoderImpl(element: element, codingPath: codingPath)
        try value.encode(to: encoder)
    }
}
