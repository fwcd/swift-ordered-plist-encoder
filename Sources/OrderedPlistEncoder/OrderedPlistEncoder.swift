import Foundation

/// An encoder that encodes to an ordered XML property list.
public struct OrderedPlistEncoder {
    public struct OutputFormatting: OptionSet {
        public let rawValue: UInt

        public static let prettyPrinted = Self(rawValue: 1 << 0)

        var xmlOptions: XMLNode.Options {
            var xmlOptions: XMLNode.Options = []
            if contains(.prettyPrinted) {
                xmlOptions.insert(.nodePrettyPrint)
            }
            return xmlOptions
        }

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }

    public var options: OutputFormatting

    public init(options: OutputFormatting = []) {
        self.options = options
    }

    /// Encodes a value to an ordered XML property list to UTF-8-encoded data.
    public func encode<Value>(_ value: Value) throws -> Data where Value: Encodable {
        guard let data = try encodeToString(value).data(using: .utf8) else {
            throw OrderedPlistEncodingError.couldNotConvertToUTF8
        }
        return data
    }

    /// Encodes a value to an ordered XML property list as `String`.
    public func encodeToString<Value>(_ value: Value) throws -> String where Value: Encodable {
        try encodeToXML(value).xmlString(options: .nodeCompactEmptyElement.union(options.xmlOptions))
    }

    /// Encodes a value to an ordered XML property list as `XMLDocument`.
    public func encodeToXML<Value>(_ value: Value) throws -> XMLDocument where Value: Encodable {
        let encoder = OrderedPlistEncoderImpl()
        try value.encode(to: encoder)

        let dtd = XMLDTD()
        dtd.name = "plist"
        dtd.publicID = "-//Apple//DTD PLIST 1.0//EN"
        dtd.systemID = "http://www.apple.com/DTDs/PropertyList-1.0.dtd"

        let rootElement = XMLElement(name: "plist")
        rootElement.addAttribute(XMLNode.attribute(withName: "version", stringValue: "1.0") as! XMLNode)
        rootElement.addChild(encoder.element)

        let document = XMLDocument()
        document.dtd = dtd
        document.addChild(rootElement)

        return document
    }
}
