import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

struct OrderedPlistEncoderImpl: Encoder {
    let codingPath: [any CodingKey]
    var userInfo: [CodingUserInfoKey: Any] { [:] }

    // Implementation note: We make pretty heavy use of the fact that
    // XML types such as `XMLElement` have reference semantics (that
    // lets encoders 'reference' a part of the tree and e.g. later encode
    // more values into it).

    private(set) var element: XMLElement

    init(element: XMLElement = XMLElement(kind: .comment), codingPath: [any CodingKey] = []) {
        self.element = element
        self.codingPath = codingPath
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        .init(KeyedOrderedPlistEncodingContainer(element: element, codingPath: codingPath))
    }

    func unkeyedContainer() -> any UnkeyedEncodingContainer {
        UnkeyedOrderedPlistEncodingContainer(element: element, codingPath: codingPath)
    }

    func singleValueContainer() -> any SingleValueEncodingContainer {
        SingleValueOrderedPlistEncodingContainer(element: element, codingPath: codingPath)
    }
}
