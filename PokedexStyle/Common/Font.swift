public enum Font: String {

    case circularStdBold = "CircularStd-Bold"
    case circularStdBook = "Circular Std Book"
    case circularStdBlack = "Circular Std Black"
}

public extension Font {

    func uiFont(_ size: CGFloat) -> UIFont {
        loadFontIfNeeded(font: self)

        guard let font = UIFont(name: self.rawValue, size: size) else {
            assertionFailure("Font could not be initialized.")
            return UIFont.systemFont(ofSize: size)
        }

        return font
    }
}

extension Font {

    static var loadedFonts = [Font]()

    func loadFontIfNeeded(font: Font) {
        guard !Font.loadedFonts.contains(font) else { return }

        guard let bundle = Bundle(identifier: "com.denevik.PokedexStyle") else {
            assertionFailure("Wrong bundle identifier for PokedexStyle.")
            return
        }

        guard let pathForResourceString = bundle.path(forResource: font.rawValue, ofType: ".ttf") else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }

        guard let fontRef = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }

        Font.loadedFonts.append(font)
    }
}

private extension Bundle {}
