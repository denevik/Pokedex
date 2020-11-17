import PokedexStyle

/// Pokemon cell to display
class PokemonCollectionViewCell: UICollectionViewCell {

    fileprivate struct Constants {
        // Cell layer
        static let layerCornerRadius: CGFloat = 15

        // Default type labels and background views constants
        static let defaultTypeLabelBackgroundViewAlpha: CGFloat = 0.4
        static let defaultTypeLabelBackgroundViewCornerRadius: CGFloat = 8
        static let defaultTypeLabelFontSize: CGFloat = 8

        // 1 Pokemon id label
        static let pokemonIdLabelFontSize: CGFloat = 14
        static let pokemonIdLabelAlpha: CGFloat = 0.12
        static let pokemonIdLabelTopConstant: CGFloat = 10
        static let pokemonIdLabelTrailingConstant: CGFloat = -4
        static let pokemonIdLabelWidthConstant: CGFloat = 60

        // 2 Name label
        static let nameLabelFontSize: CGFloat = 14
        static let nameLabelTopConstant: CGFloat = 24
        static let nameLabelLeadingConstant: CGFloat = 16
        static let nameLabelHeightConstant: CGFloat = 14

        // 3 Pokemon image view
        static let pokemonImageViewTop: CGFloat = 40
        static let pokemonImageViewLeading: CGFloat = 72
        static let pokemonImageViewTrailing: CGFloat = -7
        static let pokemonImageViewBottom: CGFloat = -1
        static let pokemonImageViewWidth: CGFloat = 76
        static let pokemonImageViewHeight: CGFloat = 71

        // 4.1 First type label background view
        static let firstTypeLabelBackgroundViewTopConstant: CGFloat = 10
        static let firstTypeLabelBackgroundViewLeadingConstant: CGFloat = 16
        static let firstTypeLabelBackgroundViewHeightConstant: CGFloat = 16

        // 4.2 Second type label background view
        static let secondTypeLabelBackgroundViewTopConstant: CGFloat = 6
        static let secondTypeLabelBackgroundViewLeadingConstant: CGFloat = 16
        static let secondTypeLabelBackgroundViewHeightConstant: CGFloat = 16
        static let secondTypeLabelBackgroundViewBottomConstant: CGFloat = -25
    }

    static let reuseIdentifier = "PokemonCell"

    private let nameLabel = UILabel()
    private var pokemonIdLabel: PokemonIdLabel?

    private var firstTypeLabelBackgroundView = UIView()
    private var firstTypeLabel = UILabel()

    private var secondTypeLabelBackgroundView = UIView()
    private var secondTypeLabel = UILabel()

    private let pokemonImageView = UIImageView()

    private let loadingIndicator = UIActivityIndicatorView()
    private let errorStackView = UIStackView()
    private let errorLabel = UILabel()
    private let errorImageView = UIImageView()

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

        loadingIndicator.stopAnimating()
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

    func configure(with item: PokemonItem) {
        switch item.state {
        case .loading:
            showLoadingIndicator()

        case .finished:
            hideLoadingIndicator()
            updateCell(with: item)
        }
    }
}

private extension PokemonCollectionViewCell {

    func commonInit() {
        contentView.layer.cornerRadius = Constants.layerCornerRadius

        // Name label
        nameLabel.font = Font.circularStdBold.uiFont(Constants.nameLabelFontSize)
        nameLabel.textColor = .white
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.nameLabelTopConstant),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.nameLabelLeadingConstant),
            nameLabel.heightAnchor.constraint(equalToConstant: Constants.nameLabelHeightConstant)
        ])

        // Pokemon image view
        pokemonImageView.contentMode = .scaleAspectFit
        contentView.addSubview(pokemonImageView)
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.pokemonImageViewTop),
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.pokemonImageViewLeading),
            pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.pokemonImageViewTrailing),
            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.pokemonImageViewBottom)
        ])

        // Loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .gray
        contentView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }

    func updateCell(with item: PokemonItem) {
        guard let types = item.types else {
            return
        }
        nameLabel.text = item.name.uppercaseFirstLetter()
        pokemonImageView.image = item.image
        contentView.backgroundColor = types.first?.color

        configureTypeLabels(with: types)
        configurePokemonIdLabel(item.id)
    }

    func configureTypeLabels(with types: [PokemonType]) {
        // first and second type labels
        configureTypeLabel(&firstTypeLabel, with: &firstTypeLabelBackgroundView)
        configureTypeLabel(&secondTypeLabel, with: &secondTypeLabelBackgroundView)
        contentView.addSubview(firstTypeLabelBackgroundView)
        contentView.addSubview(firstTypeLabel)
        NSLayoutConstraint.activate([
            firstTypeLabelBackgroundView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.firstTypeLabelBackgroundViewTopConstant),
            firstTypeLabelBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.firstTypeLabelBackgroundViewLeadingConstant),
            firstTypeLabelBackgroundView.heightAnchor.constraint(equalToConstant: Constants.firstTypeLabelBackgroundViewHeightConstant)
        ])
        contentView.addSubview(secondTypeLabelBackgroundView)
        contentView.addSubview(secondTypeLabel)
        NSLayoutConstraint.activate([
            secondTypeLabelBackgroundView.topAnchor.constraint(equalTo: firstTypeLabelBackgroundView.bottomAnchor, constant: Constants.secondTypeLabelBackgroundViewTopConstant),
            secondTypeLabelBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.secondTypeLabelBackgroundViewLeadingConstant),
            secondTypeLabelBackgroundView.heightAnchor.constraint(equalToConstant: Constants.secondTypeLabelBackgroundViewHeightConstant),
            secondTypeLabelBackgroundView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: Constants.secondTypeLabelBackgroundViewBottomConstant)
        ])

        if let firstType = types.first {
            update(typeLabel: &firstTypeLabel, with: firstType.rawValue, and: &firstTypeLabelBackgroundView)
        }

        if let secondType = types.last, let firstType = types.first, secondType != firstType {
            update(typeLabel: &secondTypeLabel, with: secondType.rawValue, and: &secondTypeLabelBackgroundView)
        }
    }


    func configureTypeLabel(_ label: inout UILabel, with backgroundView: inout UIView) {
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(Constants.defaultTypeLabelBackgroundViewAlpha)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = Constants.defaultTypeLabelBackgroundViewCornerRadius
        backgroundView.isHidden = true
        label.font = Font.circularStdBook.uiFont(Constants.defaultTypeLabelFontSize)
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

    func configurePokemonIdLabel(_ id: Int) {
        pokemonIdLabel = PokemonIdLabel(id: id)
        guard let pokemonIdLabel = pokemonIdLabel else {
            return
        }

        pokemonIdLabel.font = Font.circularStdBold.uiFont(Constants.pokemonIdLabelFontSize)
        pokemonIdLabel.textAlignment = .center
        pokemonIdLabel.textColor = UIColor.black.withAlphaComponent(Constants.pokemonIdLabelAlpha)
        pokemonIdLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pokemonIdLabel)
        NSLayoutConstraint.activate([
            pokemonIdLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.pokemonIdLabelTopConstant),
            pokemonIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.pokemonIdLabelTrailingConstant),
            pokemonIdLabel.heightAnchor.constraint(equalToConstant: pokemonIdLabel.frame.height),
            pokemonIdLabel.widthAnchor.constraint(equalToConstant: Constants.pokemonIdLabelWidthConstant)
        ])
    }
}
