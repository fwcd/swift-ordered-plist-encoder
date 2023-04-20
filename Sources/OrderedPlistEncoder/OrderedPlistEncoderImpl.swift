import Foundation
#if canImport(FoundationXML)
import FoundatiomXML
#endif

struct OrderedPlistEncoderImpl: Encoder {
    let codingPath: [any CodingKey]
    var userInfo: [CodingUserInfoKey: Any] { [:] }

    private(set) var element: XMLElement

    init(element: XMLElement = .init(), codingPath: [any CodingKey] = []) {
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
