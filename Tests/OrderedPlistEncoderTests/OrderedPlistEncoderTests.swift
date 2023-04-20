import XCTest
@testable import OrderedPlistEncoder

private struct X: Codable, Hashable {
    let b: String
    let a: Int
    let c: Int
}

final class OrderedPlistEncoderTests: XCTestCase {
    func testEncoder() throws {
        try assertRoundtrips(23)
        try assertRoundtrips(-9)
        try assertRoundtrips(4.5)
        try assertRoundtrips("Test this")
        try assertRoundtrips(" a string with  \nspaces and stuff   ")
        try assertRoundtrips([1, -9, 3])
        try assertRoundtrips(["hello": "a", "world": "b"])
        try assertRoundtrips(X(b: "abc", a: 3, c: -9))
    }

    private func assertRoundtrips<Value>(_ value: Value, line: UInt = #line) throws where Value: Codable & Equatable {
        let encoder = OrderedPlistEncoder()
        let decoder = PropertyListDecoder()
        let roundtripped = try decoder.decode(Value.self, from: encoder.encode(value))
        XCTAssertEqual(roundtripped, value, line: line)
    }
}
