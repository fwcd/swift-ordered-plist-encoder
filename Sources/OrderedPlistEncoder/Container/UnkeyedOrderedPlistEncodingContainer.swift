import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

struct UnkeyedOrderedPlistEncodingContainer: UnkeyedEncodingContainer {
    private let element: XMLElement
    let codingPath: [any CodingKey]
    private(set) var count: Int = 0

    init(element: XMLElement, codingPath: [any CodingKey]) {
        self.element = element
        self.codingPath = codingPath

        element.name = "array"
    }

    private mutating func addItemElement() -> XMLElement {
        let itemElement = XMLElement(kind: .comment)
        element.addChild(itemElement)
        count += 1
        return itemElement
    }

    private mutating func encodeItem(_ action: (inout SingleValueOrderedPlistEncodingContainer) throws -> Void) rethrows {
        let itemElement = addItemElement()
        var container = SingleValueOrderedPlistEncodingContainer(element: itemElement, codingPath: codingPath)
        try action(&container)
    }

    mutating func encodeNil() {
        encodeItem { container in
            container.encodeNil()
        }
    }

    mutating func encode(_ value: Bool) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: String) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Double) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Float) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int8) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int16) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int32) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int64) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt8) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt16) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt32) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt64) {
        encodeItem { container in
            container.encode(value)
        }
    }

    mutating func encode<T>(_ value: T) throws where T: Encodable {
        try encodeItem { container in
            try container.encode(EncodableValue(value))
        }
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        .init(KeyedOrderedPlistEncodingContainer<NestedKey>(element: addItemElement(), codingPath: codingPath))
    }

    mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        UnkeyedOrderedPlistEncodingContainer(element: addItemElement(), codingPath: codingPath)
    }

    mutating func superEncoder() -> any Encoder {
        fatalError("Super-encoding is not supported by UnkeyedOrderedPlistEncodingContainer yet!")
    }
}
