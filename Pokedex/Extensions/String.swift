import Foundation

extension String {

    func uppercaseFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func uppercaseFirstLetter() {
        self = self.uppercaseFirstLetter()
    }
}
