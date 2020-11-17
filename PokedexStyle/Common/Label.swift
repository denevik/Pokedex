public class PokemonIdLabel: UILabel {

    private let id: Int

    public init(id: Int) {
        self.id = id
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        textColor = .white

        let upperBound = 5 - Array(String(id)).count
        var labelText = "#"
        for _ in 0..<upperBound {
            labelText.append("0")
        }
        labelText += String(id)

        text = labelText
        sizeToFit()
    }
}
