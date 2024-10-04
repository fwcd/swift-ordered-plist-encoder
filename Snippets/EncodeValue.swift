import OrderedPlistEncoder

struct Planet: Encodable {
    let name: String
    let mass: Double
}

let planets = [
    // Source: https://nssdc.gsfc.nasa.gov/planetary/factsheet/
    Planet(name: "Mercury", mass: 3.3e23),
    Planet(name: "Venus", mass: 4.82e24),
    Planet(name: "Earth", mass: 5.97e24),
    Planet(name: "Mars", mass: 6.42e23),
    Planet(name: "Jupiter", mass: 1.898e27),
    Planet(name: "Saturn", mass: 5.68e26),
    Planet(name: "Uranus", mass: 8.68e25),
    Planet(name: "Neptune", mass: 1.02e26),
    Planet(name: "Pluto", mass: 1.3e22),
]

let encoder = OrderedPlistEncoder(options: .init(
    prettyPrint: .init(indent: "  ")
))

print(try encoder.encodeToString(planets))
