import PokedexStyle

class PokemonDetailsViewController: UIViewController {

    private struct Constants {

        static let defaultNavigationBarHeight: CGFloat = 44
        static let largeTitlesNavigationBarCenterY: CGFloat = 22.25

        // 1 Pokemon id label
        static let pokemonIdLabelFontSize: CGFloat = 18
        static let pokemonIdLabelTrailingConstant: CGFloat = -25


        // 2 Background card view
        static let infoCardBackgroundViewCornerRadius: CGFloat = 35
        static let infoCardBackgroundViewBottomConstant: CGFloat = 100
        static let infoCardBackgroundViewTopConstant: CGFloat = 376


        // 3 Pokemon image view
        static let pokemonImageViewTopConstant: CGFloat = -170
        static let pokemonImageViewHeightConstant: CGFloat = 250
        static let pokemonImageViewWidthConstant: CGFloat = 200


        // 4 About label
        static let aboutLabelFontSize: CGFloat = 16
        static let aboutLabelText = "About"
        static let aboutLabelTopConstant: CGFloat = 46
        static let aboutLabelLeadingConstant: CGFloat = 27
        static let aboutLabelTrailingConstant: CGFloat = -27


        // 5 Description label
        static let descriptionLabelFontSize: CGFloat = 14
        static let descriptionLabelNumberOfLines = 0
        static let descriptionLabelTopConstant: CGFloat = 19
        static let descriptionLabelLeadingConstant: CGFloat = 27
        static let descriptionLabelTrailingConstant: CGFloat = -29


        // 6 Body stats view
        static let bodyStatsViewCornerRadius: CGFloat = 15
        static let bodyStatsViewShadowRadius: CGFloat = 15
        static let bodyStatsViewShadowOpacity: Float = 0.20
        static let bodyStatsViewShadowOffset = CGSize(width: 0, height: 10)
        static let bodyStatsViewDefaultMultiplier: Double = 10
        static let bodyStatsViewTopConstant: CGFloat = 28
        static let bodyStatsViewLeadingConstant: CGFloat = 28
        static let bodyStatsViewTrailingConstant: CGFloat = -27
        static let bodyStatsViewHeightConstant: CGFloat = 85

        // 6.1 Height container view
        static let heightContainerViewTopConstant: CGFloat = 16
        static let heightContainerViewLeadingConstant: CGFloat = 20
        static let heightContainerViewBottomConstant: CGFloat = -17
        static let heightContainerViewWidthConstant: CGFloat = 100
        // 6.1.2 Height label
        static let heightLabelFontSize: CGFloat = 14
        static let heightLabelAlpha: CGFloat = 0.4
        static let heightLabelText = "Height"
        static let heightLabelHeightConstant: CGFloat = 14
        // 6.1.3 Height value label
        static let heightValueLabelFontSize: CGFloat = 14
        static let heightValueFeetMultiplier = 0.0328084
        static let heightValueTopConstant: CGFloat = 11

        // 6.2 Weight container view
        static let weightContainerViewTopConstant: CGFloat = 16
        static let weightContainerViewTrailingConstant: CGFloat = -20
        static let weightContainerViewLeadingConstant: CGFloat = 45
        static let weightContainerViewBottomConstant: CGFloat = -17
        // 6.2.2 Weight label
        static let weightLabelFontSize: CGFloat = 14
        static let weightLabelAlpha: CGFloat = 0.4
        static let weightLabelText = "Weight"
        static let weightLabelHeightConstant: CGFloat = 20
        // 6.2.3 Weight value label
        static let weightValueLabelFontSize: CGFloat = 14
        static let weightValueLabelLBSMultiplier = 2.20462
        static let weightValueLabelTopConstant: CGFloat = 11


        // 7 Breed container
        static let breedContainerTopConstant: CGFloat = 31
        static let breedContainerLeadingConstant: CGFloat = 28
        static let breedContainerTrailingConstant: CGFloat = -52

        // 7.1 Breed label
        static let breedLabelFontSize: CGFloat = 16
        static let breedLabelText = "Breeding"
        static let breedSectionDefaultLabelWidth: CGFloat = 88
        static let breedLabelHeightConstant: CGFloat = 20

        // 7.2 Types container
        static let typesContainerTopConstant: CGFloat = 16
        static let typesContainerHeightConstant: CGFloat = 16
        // 7.2.1 Types label
        static let typesLabelFontSize: CGFloat = 14
        static let typesLabelAlpha: CGFloat = 0.6
        static let typesLabelText = "Types"
        // 7.2.2 Types value label
        static let typesValueLabelFontSize: CGFloat = 14
        static let typesValueLabelSeparator = ", "
        static let typesValueLabelLeadingConstant: CGFloat = 10
        static let typesValueLabelTrailingConstant: CGFloat = 0

        // 7.3 Egg groups container
        static let eggGroupsContainerTopConstant: CGFloat = 16
        static let eggGroupsContainerHeightConstant: CGFloat = 16
        // 7.3.1 Egg groups label
        static let eggGroupsLabelFontSize: CGFloat = 14
        static let eggGroupsLabelAlpha: CGFloat = 0.6
        static let eggGroupsLabelText = "Egg groups"
        // 7.3.2 Egg groups value label
        static let eggGroupsValueLabelFontSize: CGFloat = 14
        static let eggGroupsValueLabelLeadingConstant: CGFloat = 10
        static let eggGroupsValueLabelTrailingConstant: CGFloat = 0

        // 7.4 Egg cycle container
        static let eggCycleContainerTopConstant: CGFloat = 16
        static let eggCycleContainerHeightConstant: CGFloat = 16
        // 7.4.1 Egg cycle label
        static let eggCycleLabelFontSize: CGFloat = 14
        static let eggCycleLabelAlpha: CGFloat = 0.6
        static let eggCycleLabelText = "Egg Cycle"
        // 7.4.2 Egg cycle value label
        static let eggCycleValueLabelFontSize: CGFloat = 14
        static let eggCycleValueLabelLeadingConstant: CGFloat = 10
        static let eggCycleValueLabelTrailingConstant: CGFloat = 10
    }

    private var viewModel: PokemonDetailsViewModelProtocol
    private let screenSize: CGRect = UIScreen.main.bounds

    private lazy var pokemonIdLabel: PokemonIdLabel = {
        let pokemonLabelId = PokemonIdLabel(id: viewModel.pokemon.id)
        pokemonLabelId.font = Font.circularStdBlack.uiFont(Constants.pokemonIdLabelFontSize)
        pokemonLabelId.translatesAutoresizingMaskIntoConstraints = false

        return pokemonLabelId
    }()

    // MARK: - Background card view

    private lazy var infoCardBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.infoCardBackgroundViewCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.pokemon.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // MARK: - About section

    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.aboutLabelFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.aboutLabelText

        return label
    }()

    // MARK: - Description section

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.descriptionLabelFontSize)
        label.textColor = .black
        label.numberOfLines = Constants.descriptionLabelNumberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.pokemon.description

        return label
    }()

    // MARK: - Height and weight section

    private lazy var bodyStatsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.bodyStatsViewCornerRadius
        view.layer.shadowRadius = Constants.bodyStatsViewShadowRadius
        view.layer.shadowOpacity = Constants.bodyStatsViewShadowOpacity
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = Constants.bodyStatsViewShadowOffset

        return view
    }()

    // Height

    private lazy var heightContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.heightLabelFontSize)
        label.textColor = UIColor.black.withAlphaComponent(Constants.heightLabelAlpha)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.heightLabelText

        return label
    }()

    private lazy var heightValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.heightValueLabelFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%.1f\" (%.2f cm)", (Double(viewModel.pokemon.height) * Constants.heightValueFeetMultiplier) * Constants.bodyStatsViewDefaultMultiplier, Double(viewModel.pokemon.height) / Constants.bodyStatsViewDefaultMultiplier)

        return label
    }()

    // Weight

    private lazy var weightContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.weightLabelFontSize)
        label.textColor = UIColor.black.withAlphaComponent(Constants.weightLabelAlpha)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.weightLabelText

        return label
    }()

    private lazy var weightValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.weightValueLabelFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%.1f lbs (%.1f kg)", (Double(viewModel.pokemon.weight) / Constants.bodyStatsViewDefaultMultiplier) * Constants.weightValueLabelLBSMultiplier, Double(viewModel.pokemon.weight) / Constants.bodyStatsViewDefaultMultiplier)

        return label
    }()

    // MARK: - Breed section

    private lazy var breedContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // Breed label

    private lazy var breedLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBold.uiFont(Constants.breedLabelFontSize)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.breedLabelText

        return label
    }()

    // Types

    private lazy var typesContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var typesLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.typesLabelFontSize)
        label.textColor = UIColor.black.withAlphaComponent(Constants.typesLabelAlpha)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.typesLabelText

        return label
    }()

    private lazy var typesValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.typesValueLabelFontSize)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        if viewModel.pokemonTypes.count > 1, let firstType = viewModel.pokemonTypes.first?.rawValue.uppercaseFirstLetter(),
           let secondType = viewModel.pokemonTypes.last?.rawValue.uppercaseFirstLetter() {
            label.text = firstType + Constants.typesValueLabelSeparator + secondType
        } else {
            label.text = (viewModel.pokemonTypes.first?.rawValue ?? viewModel.pokemonTypes.last?.rawValue)?.uppercaseFirstLetter()
        }

        return label
    }()

    // Egg groups

    private lazy var eggGroupsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var eggGroupsLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.eggGroupsLabelFontSize)
        label.textColor = UIColor.black.withAlphaComponent(Constants.eggGroupsLabelAlpha)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.eggGroupsLabelText

        return label
    }()

    private lazy var eggGroupsValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.eggGroupsValueLabelFontSize)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.pokemon.breed?.eggGroups.first?.name.uppercaseFirstLetter()

        return label
    }()

    // Egg cycle

    private lazy var eggCycleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var eggCycleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.eggCycleLabelFontSize)
        label.textColor = UIColor.black.withAlphaComponent(Constants.eggCycleLabelAlpha)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.eggCycleLabelText

        return label
    }()

    private lazy var eggCycleValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.eggCycleValueLabelFontSize)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.pokemon.breed?.eggGroups.last?.name.uppercaseFirstLetter()

        return label
    }()

    init(viewModel: PokemonDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.tintColor = UIColor.white
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        pokemonIdLabel.removeFromSuperview()
    }
}

private extension PokemonDetailsViewController {

    func setupViews() {
        guard let navigationController = navigationController else { return }

        view.backgroundColor = viewModel.pokemonTypes.first?.color
        navigationItem.title = viewModel.pokemon.name.uppercaseFirstLetter()

        // Pokemon label id
        navigationController.navigationBar.addSubview(pokemonIdLabel)
        NSLayoutConstraint.activate([
            pokemonIdLabel.trailingAnchor.constraint(equalTo: navigationController.navigationBar.trailingAnchor, constant: Constants.pokemonIdLabelTrailingConstant),
            pokemonIdLabel.topAnchor.constraint(equalTo: navigationController.navigationBar.topAnchor, constant: Constants.defaultNavigationBarHeight + Constants.largeTitlesNavigationBarCenterY - (pokemonIdLabel.frame.height / 2))
        ])

        // Info card background
        view.addSubview(infoCardBackgroundView)
        NSLayoutConstraint.activate([
            infoCardBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.infoCardBackgroundViewBottomConstant),
            infoCardBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoCardBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoCardBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.infoCardBackgroundViewTopConstant)
        ])

        // Pokemon image view
        infoCardBackgroundView.addSubview(pokemonImageView)
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: infoCardBackgroundView.topAnchor, constant: Constants.pokemonImageViewTopConstant),
            pokemonImageView.centerXAnchor.constraint(equalTo: infoCardBackgroundView.centerXAnchor),
            pokemonImageView.heightAnchor.constraint(equalToConstant: Constants.pokemonImageViewHeightConstant),
            pokemonImageView.widthAnchor.constraint(equalToConstant: Constants.pokemonImageViewWidthConstant)
        ])

        // About label
        infoCardBackgroundView.addSubview(aboutLabel)
        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(equalTo: infoCardBackgroundView.topAnchor, constant: Constants.aboutLabelTopConstant),
            aboutLabel.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: Constants.aboutLabelLeadingConstant),
            aboutLabel.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: Constants.aboutLabelTrailingConstant)
        ])

        // Description label
        infoCardBackgroundView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: Constants.descriptionLabelTopConstant),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: Constants.descriptionLabelLeadingConstant),
            descriptionLabel.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: Constants.descriptionLabelTrailingConstant)
        ])

        // Body stats view
        infoCardBackgroundView.addSubview(bodyStatsView)
        NSLayoutConstraint.activate([
            bodyStatsView.topAnchor.constraint(lessThanOrEqualTo: descriptionLabel.bottomAnchor, constant: Constants.bodyStatsViewTopConstant),
            bodyStatsView.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: Constants.bodyStatsViewLeadingConstant),
            bodyStatsView.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: Constants.bodyStatsViewTrailingConstant),
            bodyStatsView.heightAnchor.constraint(equalToConstant: Constants.bodyStatsViewHeightConstant)
        ])

        // Height
        heightContainerView.addSubview(heightLabel)
        NSLayoutConstraint.activate([
            heightLabel.topAnchor.constraint(equalTo: heightContainerView.topAnchor),
            heightLabel.leadingAnchor.constraint(equalTo: heightContainerView.leadingAnchor),
            heightLabel.trailingAnchor.constraint(equalTo: heightContainerView.trailingAnchor),
            heightLabel.heightAnchor.constraint(equalToConstant: Constants.heightLabelHeightConstant)
        ])

        heightContainerView.addSubview(heightValueLabel)
        NSLayoutConstraint.activate([
            heightValueLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: Constants.heightValueTopConstant),
            heightValueLabel.leadingAnchor.constraint(equalTo: heightContainerView.leadingAnchor),
            heightValueLabel.trailingAnchor.constraint(equalTo: heightContainerView.trailingAnchor),
            heightValueLabel.bottomAnchor.constraint(equalTo: heightContainerView.bottomAnchor)
        ])

        bodyStatsView.addSubview(heightContainerView)
        NSLayoutConstraint.activate([
            heightContainerView.topAnchor.constraint(equalTo: bodyStatsView.topAnchor, constant: Constants.heightContainerViewTopConstant),
            heightContainerView.leadingAnchor.constraint(equalTo: bodyStatsView.leadingAnchor, constant: Constants.heightContainerViewLeadingConstant),
            heightContainerView.bottomAnchor.constraint(equalTo: bodyStatsView.bottomAnchor, constant: Constants.heightContainerViewBottomConstant),
            heightContainerView.widthAnchor.constraint(equalToConstant: Constants.heightContainerViewWidthConstant)
        ])

        // Weight
        weightContainerView.addSubview(weightLabel)
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: weightContainerView.topAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: weightContainerView.leadingAnchor),
            weightLabel.trailingAnchor.constraint(equalTo: weightContainerView.trailingAnchor),
            weightLabel.heightAnchor.constraint(equalToConstant: Constants.weightLabelHeightConstant)
        ])

        weightContainerView.addSubview(weightValueLabel)
        NSLayoutConstraint.activate([
            weightValueLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: Constants.weightValueLabelTopConstant),
            weightValueLabel.leadingAnchor.constraint(equalTo: weightContainerView.leadingAnchor),
            weightValueLabel.trailingAnchor.constraint(equalTo: weightContainerView.trailingAnchor),
            weightValueLabel.bottomAnchor.constraint(equalTo: weightContainerView.bottomAnchor)
        ])

        bodyStatsView.addSubview(weightContainerView)
        NSLayoutConstraint.activate([
            weightContainerView.topAnchor.constraint(equalTo: bodyStatsView.topAnchor, constant: Constants.weightContainerViewTopConstant),
            weightContainerView.trailingAnchor.constraint(equalTo: bodyStatsView.trailingAnchor, constant: Constants.weightContainerViewTrailingConstant),
            weightContainerView.leadingAnchor.constraint(equalTo: heightContainerView.trailingAnchor, constant: Constants.weightContainerViewLeadingConstant),
            weightContainerView.bottomAnchor.constraint(equalTo: bodyStatsView.bottomAnchor, constant: Constants.weightContainerViewBottomConstant)
        ])

        // Breed
        infoCardBackgroundView.addSubview(breedContainer)
        NSLayoutConstraint.activate([
            breedContainer.topAnchor.constraint(equalTo: bodyStatsView.bottomAnchor, constant: Constants.breedContainerTopConstant),
            breedContainer.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: Constants.breedContainerLeadingConstant),
            breedContainer.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: Constants.breedContainerTrailingConstant),
            breedContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        breedContainer.addSubview(breedLabel)
        NSLayoutConstraint.activate([
            breedLabel.topAnchor.constraint(equalTo: breedContainer.topAnchor),
            breedLabel.leadingAnchor.constraint(equalTo: breedContainer.leadingAnchor),
            breedLabel.heightAnchor.constraint(equalToConstant: Constants.breedLabelHeightConstant)
        ])

        // Types
        breedContainer.addSubview(typesContainer)
        NSLayoutConstraint.activate([
            typesContainer.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: Constants.typesContainerTopConstant),
            typesContainer.leadingAnchor.constraint(equalTo: breedContainer.leadingAnchor),
            typesContainer.trailingAnchor.constraint(equalTo: breedContainer.trailingAnchor),
            typesContainer.heightAnchor.constraint(equalToConstant: Constants.typesContainerHeightConstant)
        ])

        typesContainer.addSubview(typesLabel)
        NSLayoutConstraint.activate([
            typesLabel.topAnchor.constraint(equalTo: typesContainer.topAnchor),
            typesLabel.leadingAnchor.constraint(equalTo: typesContainer.leadingAnchor),
            typesLabel.bottomAnchor.constraint(equalTo: typesContainer.bottomAnchor),
            typesLabel.widthAnchor.constraint(equalToConstant: Constants.breedSectionDefaultLabelWidth)
        ])

        typesContainer.addSubview(typesValueLabel)
        NSLayoutConstraint.activate([
            typesValueLabel.topAnchor.constraint(equalTo: typesContainer.topAnchor),
            typesValueLabel.leadingAnchor.constraint(equalTo: typesLabel.trailingAnchor, constant: Constants.typesValueLabelLeadingConstant),
            typesValueLabel.trailingAnchor.constraint(greaterThanOrEqualTo: typesContainer.trailingAnchor, constant: Constants.typesValueLabelTrailingConstant),
            typesLabel.bottomAnchor.constraint(equalTo: typesContainer.bottomAnchor)
        ])

        // Egg Groups
        breedContainer.addSubview(eggGroupsContainer)
        NSLayoutConstraint.activate([
            eggGroupsContainer.topAnchor.constraint(equalTo: typesContainer.bottomAnchor, constant: Constants.eggGroupsContainerTopConstant),
            eggGroupsContainer.leadingAnchor.constraint(equalTo: breedContainer.leadingAnchor),
            eggGroupsContainer.trailingAnchor.constraint(equalTo: breedContainer.trailingAnchor),
            eggGroupsContainer.heightAnchor.constraint(equalToConstant: Constants.eggGroupsContainerHeightConstant)
        ])

        eggGroupsContainer.addSubview(eggGroupsLabel)
        NSLayoutConstraint.activate([
            eggGroupsLabel.topAnchor.constraint(equalTo: eggGroupsContainer.topAnchor),
            eggGroupsLabel.leadingAnchor.constraint(equalTo: eggGroupsContainer.leadingAnchor),
            eggGroupsLabel.bottomAnchor.constraint(equalTo: eggGroupsContainer.bottomAnchor),
            eggGroupsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.breedSectionDefaultLabelWidth)
        ])

        eggGroupsContainer.addSubview(eggGroupsValueLabel)
        NSLayoutConstraint.activate([
            eggGroupsValueLabel.topAnchor.constraint(equalTo: eggGroupsContainer.topAnchor),
            eggGroupsValueLabel.leadingAnchor.constraint(equalTo: eggGroupsLabel.trailingAnchor, constant: Constants.eggGroupsValueLabelLeadingConstant),
            eggGroupsValueLabel.trailingAnchor.constraint(greaterThanOrEqualTo: eggGroupsContainer.trailingAnchor, constant: Constants.eggGroupsValueLabelTrailingConstant),
            eggGroupsValueLabel.bottomAnchor.constraint(equalTo: eggGroupsContainer.bottomAnchor)
        ])

        // Egg Cycle
        breedContainer.addSubview(eggCycleContainer)
        NSLayoutConstraint.activate([
            eggCycleContainer.topAnchor.constraint(equalTo: eggGroupsContainer.bottomAnchor, constant: Constants.eggCycleContainerTopConstant),
            eggCycleContainer.leadingAnchor.constraint(equalTo: breedContainer.leadingAnchor),
            eggCycleContainer.trailingAnchor.constraint(equalTo: breedContainer.trailingAnchor),
            eggCycleContainer.bottomAnchor.constraint(equalTo: breedContainer.bottomAnchor),
            eggCycleContainer.heightAnchor.constraint(equalToConstant: Constants.eggCycleContainerHeightConstant)
        ])

        eggCycleContainer.addSubview(eggCycleLabel)
        NSLayoutConstraint.activate([
            eggCycleLabel.topAnchor.constraint(equalTo: eggCycleContainer.topAnchor),
            eggCycleLabel.leadingAnchor.constraint(equalTo: eggCycleContainer.leadingAnchor),
            eggCycleLabel.bottomAnchor.constraint(equalTo: eggCycleContainer.bottomAnchor),
            eggCycleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.breedSectionDefaultLabelWidth)
        ])

        eggCycleContainer.addSubview(eggCycleValueLabel)
        NSLayoutConstraint.activate([
            eggCycleValueLabel.topAnchor.constraint(equalTo: eggCycleContainer.topAnchor),
            eggCycleValueLabel.leadingAnchor.constraint(equalTo: eggCycleLabel.trailingAnchor, constant: Constants.eggCycleValueLabelLeadingConstant),
            eggCycleValueLabel.trailingAnchor.constraint(greaterThanOrEqualTo: eggCycleContainer.trailingAnchor, constant: Constants.eggCycleValueLabelTrailingConstant),
            eggCycleValueLabel.bottomAnchor.constraint(equalTo: eggCycleContainer.bottomAnchor)
        ])
    }
}
