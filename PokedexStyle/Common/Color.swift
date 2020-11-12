public enum PokemonType: String, RawRepresentable {
    case fighting
    case rock
    case bug
    case ghost
    case electric
    case water
    case ice
    case dragon
    case fire
    case flying
    case psychic
    case ground
    case normal
    case dark
    case steel
    case fairy
    case grass
    case poison

    public var color: UIColor {
        switch self {
        case .fire:
            return from(hex: "FB6C6C")

        case .water, .ice, .dragon:
            return from(hex: "77BDFE")

        case .electric:
            return from(hex: "FFCE4B")

        case .normal, .ground, .rock, .fighting, .bug:
            return from(hex: "D1938C")

        case .grass, .poison, .flying:
            return from(hex: "48D0B0")

        case .fairy, .psychic, .ghost, .dark:
            return from(hex: "A06EB4")

        case .steel:
            return from(hex: "D4D4D5")
        }
    }
}

private extension PokemonType {

    func from(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

