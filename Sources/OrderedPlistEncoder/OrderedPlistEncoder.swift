import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

/// Matches line indents, along with the preceding newline (due to the lack of support for lookbehind).
nonisolated(unsafe) private let indentRegex = #/(?<prefix>(?:^|\n))(?<indent>[ \t]+)/#

/// An encoder that encodes to an ordered XML property list.
public struct OrderedPlistEncoder: Sendable {
    public var options: Options

    public init(options: Options = .init()) {
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
        let document = try encodeToXML(value)
        var xmlString = document.xmlString(options: .init(options))

        // Unfortunately, Foundation's XMLNode provides no native way to
        // customize the indent size, so we need to patch it manually
        // (or implement #3, but patching the indent seems safer than
        // handling potential edge cases with escaping for now)
        if let targetIndentSize = options.prettyPrint?.indentSize,
           let sourceIndentSize = (try? indentRegex.firstMatch(in: xmlString))?.output.indent.count {
            let targetIndent = String(repeating: " ", count: targetIndentSize)
            let sourceIndent = String(repeating: " ", count: sourceIndentSize)

            xmlString.replace(indentRegex) { match in
                match.output.prefix + match.output.indent.replacing(sourceIndent, with: targetIndent)
            }
        }

        return xmlString
    }

    /// Encodes a value to an ordered XML property list as `XMLDocument`.
    public func encodeToXML<Value>(_ value: Value) throws -> XMLDocument where Value: Encodable {
        let encoder = OrderedPlistEncoderImpl()
        try EncodableValue(value).encode(to: encoder)

        let dtd = XMLDTD()
        dtd.name = "plist"
        dtd.publicID = "-//Apple//DTD PLIST 1.0//EN"
        dtd.systemID = "http://www.apple.com/DTDs/PropertyList-1.0.dtd"

        let rootElement = XMLElement(name: "plist")
        rootElement.addAttribute(XMLNode.attribute(withName: "version", stringValue: "1.0") as! XMLNode)
        rootElement.addChild(encoder.element)

        let document = XMLDocument()
        document.version = "1.0"
        document.characterEncoding = "UTF-8"
        document.dtd = dtd
        document.addChild(rootElement)

        return document
    }
}

extension OrderedPlistEncoder {
    public struct Options: Sendable {
        public var prettyPrint: PrettyPrint?

        public struct PrettyPrint: Sendable {
            public var indentSize: Int?

            public init(indentSize: Int? = nil) {
                self.indentSize = indentSize
            }
        }

        public init(prettyPrint: PrettyPrint? = nil) {
            self.prettyPrint = prettyPrint
        }
    }
}

extension XMLNode.Options {
    init(_ options: OrderedPlistEncoder.Options) {
        self = .nodeCompactEmptyElement
        if options.prettyPrint != nil {
            insert(.nodePrettyPrint)
        }
    }
}
