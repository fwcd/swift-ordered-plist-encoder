import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

struct KeyedOrderedPlistEncodingContainer<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {
    private let element: XMLElement
    let codingPath: [any CodingKey]

    init(element: XMLElement, codingPath: [any CodingKey]) {
        self.element = element
        self.codingPath = codingPath

        element.name = "dict"
    }

    private mutating func addChildElement(forKey key: Key) -> XMLElement {
        // TODO: Add check for duplicate keys (should we throw an EncodingError?)
        let childElement: XMLElement = .init()
        element.addChild(XMLElement(name: "key", stringValue: key.stringValue))
        element.addChild(childElement)
        return childElement
    }

    private mutating func encodeChild(forKey key: Key, _ action: (inout SingleValueOrderedPlistEncodingContainer) throws -> Void) rethrows {
        let childElement = addChildElement(forKey: key)
        var container = SingleValueOrderedPlistEncodingContainer(element: childElement, codingPath: codingPath)
        try action(&container)
    }

    mutating func encodeNil(forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encodeNil()
        }
    }

    mutating func encode(_ value: Bool, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: String, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Double, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Float, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int8, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int16, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int32, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: Int64, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt8, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt16, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt32, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode(_ value: UInt64, forKey key: Key) {
        encodeChild(forKey: key) { container in
            container.encode(value)
        }
    }

    mutating func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        try encodeChild(forKey: key) { container in
            try container.encode(value)
        }
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        .init(KeyedOrderedPlistEncodingContainer<NestedKey>(element: addChildElement(forKey: key), codingPath: codingPath + [key]))
    }

    mutating func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
        UnkeyedOrderedPlistEncodingContainer(element: addChildElement(forKey: key), codingPath: codingPath + [key])
    }

    mutating func superEncoder() -> any Encoder {
        fatalError("Super-encoding is not supported by KeyedOrderedPlistEncodingContainer yet!")
    }

    mutating func superEncoder(forKey key: Key) -> any Encoder {
        fatalError("Super-encoding for a key is not supported by KeyedOrderedPlistEncodingContainer yet!")
    }
}
