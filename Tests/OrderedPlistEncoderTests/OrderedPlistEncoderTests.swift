import XCTest
@testable import OrderedPlistEncoder

private struct X: Codable, Hashable {
    let b: String
    let a: Int
    let c: Int
}

final class OrderedPlistEncoderTests: XCTestCase {
    func testRoundtrips() throws {
        try assertRoundtrips(23)
        try assertRoundtrips(-9)
        try assertRoundtrips(4.5)
        try assertRoundtrips("Test this")
        try assertRoundtrips(" a string with  \nspaces and stuff   ")
        try assertRoundtrips([1, -9, 3])
        try assertRoundtrips(["hello": "a", "world": "b"])
        try assertRoundtrips(true)
        try assertRoundtrips(X(b: "abc", a: 3, c: -9))
    }

    func testCompactElements() throws {
        let encoder = OrderedPlistEncoder()
        XCTAssertEqual(try encoder.encodeToString(true), wrapInDocument("<true/>"))
        XCTAssertEqual(try encoder.encodeToString(true), wrapInDocument("<true/>"))
    }

    func testKeyOrder() throws {
        let encoder = OrderedPlistEncoder()
        XCTAssertEqual(try encoder.encodeToString(X(b: "a", a: -1, c: 0)), wrapInDocument("<dict><key>b</key><string>a</string><key>a</key><integer>-1</integer><key>c</key><integer>0</integer></dict>"))
    }

    private func assertRoundtrips<Value>(_ value: Value, line: UInt = #line) throws where Value: Codable & Equatable {
        let encoder = OrderedPlistEncoder()
        let decoder = PropertyListDecoder()
        let roundtripped = try decoder.decode(Value.self, from: encoder.encode(value))
        XCTAssertEqual(roundtripped, value, line: line)
    }

    private func wrapInDocument(_ inner: String) -> String {
        """
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">\(inner)</plist>
        """
    }
}
