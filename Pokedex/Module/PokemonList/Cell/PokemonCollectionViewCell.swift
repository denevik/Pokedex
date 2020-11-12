import PokedexStyle

/// Pokemon cell to display
class PokemonCollectionViewCell: UICollectionViewCell {

    struct Constants {
        static let width = 155
        static let height = 111
        static let leftInset: CGFloat = 25
        static let rightInset: CGFloat = 25
        static let bottomInset: CGFloat = 25
    }

    static let reuseIdentifier = "PokemonCell"

    private let nameLabel = UILabel()
    private var pokemonIdLabel: PokemonIdLabel?

    private var firstTypeLabelBackgroundView = UIView()
    private var firstTypeLabel = UILabel()

    private var secondTypeLabelBackgroundView = UIView()
    private var secondTypeLabel = UILabel()

    private let pokemonImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    // No xibs
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Reset label on reuse
    override func prepareForReuse() {
        super.prepareForReuse()

        contentView.backgroundColor = .clear
        nameLabel.text = ""
        pokemonIdLabel?.removeFromSuperview()
        pokemonIdLabel = nil
        pokemonImageView.image = nil

        prepareForReuse(&firstTypeLabel, with: &firstTypeLabelBackgroundView)
        prepareForReuse(&secondTypeLabel, with: &secondTypeLabelBackgroundView)
    }

    private func prepareForReuse(_ typeLabel: inout UILabel, with backgroundView: inout UIView) {
        backgroundView.removeFromSuperview()
        backgroundView = UIView()
        typeLabel.removeFromSuperview()
        typeLabel = UILabel()
    }

    // Some of the calculations left as is due to time limit

    func configure(with item: PokemonItem) {
        nameLabel.text = item.name.uppercaseFirstLetter()
        pokemonImageView.image = item.image
        contentView.backgroundColor = item.types.first?.color
        configureTypeLabels(with: item.types)

        pokemonIdLabel = PokemonIdLabel(id: item.id)
        guard let pokemonIdLabel = pokemonIdLabel else {
            return
        }

        pokemonIdLabel.font = Font.circularStdBold.uiFont(14)
        pokemonIdLabel.textAlignment = .center
        pokemonIdLabel.textColor = UIColor.black.withAlphaComponent(0.12)
        pokemonIdLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pokemonIdLabel)
        NSLayoutConstraint.activate([
            pokemonIdLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            pokemonIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            pokemonIdLabel.heightAnchor.constraint(equalToConstant: pokemonIdLabel.frame.height),
            pokemonIdLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}

private extension PokemonCollectionViewCell {

    struct CellLayoutConstaints {
        // Sadly, not all magic numbers moved to Constants

        // layer
        static let layerCornerRadius: CGFloat = 15

        // nameLabel
        static let nameLabelTop: CGFloat = 24
        static let nameLabelLeading: CGFloat = 16

        // pokemon image view
        static let pokemonImageViewTop: CGFloat = 40
        static let pokemonImageViewLeading: CGFloat = 72
        static let pokemonImageViewTrailing: CGFloat = -7
        static let pokemonImageViewBottom: CGFloat = -1
        static let pokemonImageViewWidth: CGFloat = 76
        static let pokemonImageViewHeight: CGFloat = 71
    }

    func commonInit() {
        // configure layer
        contentView.layer.cornerRadius = CellLayoutConstaints.layerCornerRadius

        // nameLabel
        nameLabel.font = Font.circularStdBold.uiFont(14)
        nameLabel.textColor = .white
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellLayoutConstaints.nameLabelTop),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellLayoutConstaints.nameLabelLeading),
            nameLabel.heightAnchor.constraint(equalToConstant: 14)
        ])

        // pokemon image view
        pokemonImageView.contentMode = .scaleAspectFit
        contentView.addSubview(pokemonImageView)
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellLayoutConstaints.pokemonImageViewTop),
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellLayoutConstaints.pokemonImageViewLeading),
            pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: CellLayoutConstaints.pokemonImageViewTrailing),
            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CellLayoutConstaints.pokemonImageViewBottom)
        ])
    }

    func configureTypeLabels(with types: [PokemonType]) {
        // first and second type labels
        configureTypeLabel(&firstTypeLabel, with: &firstTypeLabelBackgroundView)
        configureTypeLabel(&secondTypeLabel, with: &secondTypeLabelBackgroundView)
        contentView.addSubview(firstTypeLabelBackgroundView)
        contentView.addSubview(firstTypeLabel)
        NSLayoutConstraint.activate([
            firstTypeLabelBackgroundView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            firstTypeLabelBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            firstTypeLabelBackgroundView.heightAnchor.constraint(equalToConstant: 16)
        ])
        contentView.addSubview(secondTypeLabelBackgroundView)
        contentView.addSubview(secondTypeLabel)
        NSLayoutConstraint.activate([
            secondTypeLabelBackgroundView.topAnchor.constraint(equalTo: firstTypeLabelBackgroundView.bottomAnchor, constant: 6),
            secondTypeLabelBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            secondTypeLabelBackgroundView.heightAnchor.constraint(equalToConstant: 16),
            secondTypeLabelBackgroundView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -25)
        ])

        if let firstType = types.first {
            update(typeLabel: &firstTypeLabel, with: firstType.rawValue, and: &firstTypeLabelBackgroundView)
        }

        if let secondType = types.last, let firstType = types.first, secondType != firstType {
            update(typeLabel: &secondTypeLabel, with: secondType.rawValue, and: &secondTypeLabelBackgroundView)
        }
    }


    func configureTypeLabel(_ label: inout UILabel, with backgroundView: inout UIView) {
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 8
        backgroundView.isHidden = true
        label.font = Font.circularStdBook.uiFont(8)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
    }

    func update(typeLabel: inout UILabel, with text: String, and backgroundView: inout UIView) {
        typeLabel.text = text
        typeLabel.sizeToFit()
        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalToConstant: typeLabel.frame.width * 2),
            typeLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            typeLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        backgroundView.isHidden = false
        typeLabel.isHidden = false
    }
}
