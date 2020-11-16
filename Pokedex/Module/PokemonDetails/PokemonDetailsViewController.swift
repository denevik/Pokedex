import PokedexStyle

class PokemonDetailsViewController: UIViewController {

    private struct Constants {
        // Height and weight multipliers
        static let feetMultiplier = 0.0328084
        static let lbsMultiplier = 2.20462

        // Icons
        static let malePokemon = "malePokemon"
        static let femalePokemon = "femalePokemon"

        // Breed
        static let breedSectionLabelWidth: CGFloat = 88
    }

    private var viewModel: PokemonDetailsViewModelProtocol
    private let screenSize: CGRect = UIScreen.main.bounds

    private lazy var pokemonIdLabel: PokemonIdLabel = {
        let pokemonLabelId = PokemonIdLabel(id: viewModel.pokemon.id)
        pokemonLabelId.font = Font.circularStdBlack.uiFont(18)
        pokemonLabelId.translatesAutoresizingMaskIntoConstraints = false

        return pokemonLabelId
    }()

    // MARK: - Background card view

    private lazy var infoCardBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.pokemonImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // MARK: - About section

    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "About"
        //        label.textAlignment = .center

        return label
    }()

    // MARK: - Description section

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.pokemon.description

        return label
    }()

    // MARK: - Height and weight section

    private lazy var bodyStatsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)

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
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Height"

        return label
    }()

    private lazy var heightValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%.1f\" (%.2f cm)", (Double(viewModel.pokemon.height) * Constants.feetMultiplier) * 10, Double(viewModel.pokemon.height) / 10)

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
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Weight"

        return label
    }()

    private lazy var weightValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%.1f lbs (%.1f kg)", (Double(viewModel.pokemon.weight) / 10) * Constants.lbsMultiplier, Double(viewModel.pokemon.weight) / 10)

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
        label.font = Font.circularStdBold.uiFont(16)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Breeding"

        return label
    }()

    // Gender

    private lazy var genderContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Gender"

        return label
    }()

    private lazy var malePercentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var maleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.malePokemon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var maleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        // This is hardcoded by now because I did not expect so hard calculations
        // for all this generations etc. But it will be in the future
        label.text = "87.5%"

        return label
    }()

    private lazy var femalePercentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var femaleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.femalePokemon)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var femaleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        // Same here, calculations for generation ratio is insane
        // Do not have enough time for that at this moment
        label.text = "12.5%"

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
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Egg groups"

        return label
    }()

    private lazy var groupLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.pokemon.breed?.eggGroups.first?.name.uppercaseFirstLetter()// "Monster"

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
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Egg Cycle"

        return label
    }()

    private lazy var cycleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.pokemon.breed?.eggGroups.last?.name.uppercaseFirstLetter() //"Grass"

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

    // There are still lots of "magic numbers" due to time limit
    func setupViews() {
        guard let navigationController = navigationController else { return }

        view.backgroundColor = viewModel.pokemonTypes.first?.color
        navigationItem.title = viewModel.pokemon.name.uppercaseFirstLetter()

        navigationController.navigationBar.addSubview(pokemonIdLabel)
        NSLayoutConstraint.activate([
            pokemonIdLabel.trailingAnchor.constraint(equalTo: navigationController.navigationBar.trailingAnchor, constant: -25),
            pokemonIdLabel.topAnchor.constraint(equalTo: navigationController.navigationBar.topAnchor, constant: 44 + 22.25 - (pokemonIdLabel.frame.height / 2))
        ])

        // Info card background
        view.addSubview(infoCardBackgroundView)
        NSLayoutConstraint.activate([
            infoCardBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            infoCardBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoCardBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoCardBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: 376)
        ])

        // Pokemon image view
        infoCardBackgroundView.addSubview(pokemonImageView)
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: infoCardBackgroundView.topAnchor, constant: -(screenSize.height * 30 / 100) * 0.7),
            pokemonImageView.centerXAnchor.constraint(equalTo: infoCardBackgroundView.centerXAnchor),
            pokemonImageView.heightAnchor.constraint(equalToConstant:  (screenSize.height * 30 / 100)),
            pokemonImageView.widthAnchor.constraint(equalToConstant: (screenSize.width * 50) / 100)
        ])

        // About label
        infoCardBackgroundView.addSubview(aboutLabel)
        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(equalTo: infoCardBackgroundView.topAnchor, constant: 46),
            aboutLabel.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: 27),
            aboutLabel.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: -27)
            //            aboutLabel.heightAnchor.constraint(equalToConstant: 23) // TO REMOVE
        ])

        // Description label
        infoCardBackgroundView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 19),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: 27),
            descriptionLabel.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: -29)
        ])

        // Height and weight
        infoCardBackgroundView.addSubview(bodyStatsView)
        NSLayoutConstraint.activate([
            bodyStatsView.topAnchor.constraint(lessThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 28),
            bodyStatsView.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: 28),
            bodyStatsView.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: -27),
            bodyStatsView.heightAnchor.constraint(equalToConstant: 85)
        ])

        // Height
        heightContainerView.addSubview(heightLabel)
        NSLayoutConstraint.activate([
            heightLabel.topAnchor.constraint(equalTo: heightContainerView.topAnchor),
            heightLabel.leadingAnchor.constraint(equalTo: heightContainerView.leadingAnchor),
            heightLabel.trailingAnchor.constraint(equalTo: heightContainerView.trailingAnchor),
            heightLabel.heightAnchor.constraint(equalToConstant: 14)
        ])

        heightContainerView.addSubview(heightValueLabel)
        NSLayoutConstraint.activate([
            heightValueLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 11),
            heightValueLabel.leadingAnchor.constraint(equalTo: heightContainerView.leadingAnchor),
            heightValueLabel.trailingAnchor.constraint(equalTo: heightContainerView.trailingAnchor),
            heightValueLabel.bottomAnchor.constraint(equalTo: heightContainerView.bottomAnchor)
        ])

        bodyStatsView.addSubview(heightContainerView) // Height Container
        NSLayoutConstraint.activate([
            heightContainerView.topAnchor.constraint(equalTo: bodyStatsView.topAnchor, constant: 16),
            heightContainerView.leadingAnchor.constraint(equalTo: bodyStatsView.leadingAnchor, constant: 20),
            heightContainerView.bottomAnchor.constraint(equalTo: bodyStatsView.bottomAnchor, constant: -17),
            heightContainerView.widthAnchor.constraint(equalToConstant: 100)
        ])

        // Weight
        weightContainerView.addSubview(weightLabel)
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: weightContainerView.topAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: weightContainerView.leadingAnchor),
            weightLabel.trailingAnchor.constraint(equalTo: weightContainerView.trailingAnchor),
            weightLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        weightContainerView.addSubview(weightValueLabel)
        NSLayoutConstraint.activate([
            weightValueLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 11),
            weightValueLabel.leadingAnchor.constraint(equalTo: weightContainerView.leadingAnchor),
            weightValueLabel.trailingAnchor.constraint(equalTo: weightContainerView.trailingAnchor),
            weightValueLabel.bottomAnchor.constraint(equalTo: weightContainerView.bottomAnchor)
        ])

        bodyStatsView.addSubview(weightContainerView) // Weight Container
        NSLayoutConstraint.activate([
            weightContainerView.topAnchor.constraint(equalTo: bodyStatsView.topAnchor, constant: 16),
            weightContainerView.trailingAnchor.constraint(equalTo: bodyStatsView.trailingAnchor, constant: -20),
            weightContainerView.leadingAnchor.constraint(equalTo: heightContainerView.trailingAnchor, constant: 45),
            weightContainerView.bottomAnchor.constraint(equalTo: bodyStatsView.bottomAnchor, constant: -17)
        ])

        // Breed
        infoCardBackgroundView.addSubview(breedContainer)
        NSLayoutConstraint.activate([
            breedContainer.topAnchor.constraint(equalTo: bodyStatsView.bottomAnchor, constant: 31),
            breedContainer.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: 28),
            breedContainer.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: -52),
            breedContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) // -15
        ])

        breedContainer.addSubview(breedLabel)
        NSLayoutConstraint.activate([
            breedLabel.topAnchor.constraint(equalTo: breedContainer.topAnchor),
            breedLabel.leadingAnchor.constraint(equalTo: breedContainer.leadingAnchor),
            breedLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Gender
        breedContainer.addSubview(genderContainer)
        NSLayoutConstraint.activate([
            genderContainer.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 12),
            genderContainer.leadingAnchor.constraint(equalTo: breedContainer.leadingAnchor),
            genderContainer.trailingAnchor.constraint(equalTo: breedContainer.trailingAnchor),
            genderContainer.heightAnchor.constraint(equalToConstant: 16)
        ])

        genderContainer.addSubview(genderLabel)
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: genderContainer.topAnchor),
            genderLabel.leadingAnchor.constraint(equalTo: genderContainer.leadingAnchor),
            genderLabel.bottomAnchor.constraint(equalTo: genderContainer.bottomAnchor),
            genderLabel.widthAnchor.constraint(equalToConstant: Constants.breedSectionLabelWidth)
        ])

        genderContainer.addSubview(malePercentContainer)
        NSLayoutConstraint.activate([
            malePercentContainer.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 10),
            malePercentContainer.topAnchor.constraint(equalTo: genderContainer.topAnchor),
            malePercentContainer.bottomAnchor.constraint(equalTo: genderContainer.bottomAnchor),
            malePercentContainer.widthAnchor.constraint(equalToConstant: 70)
        ])

        malePercentContainer.addSubview(maleImageView)
        NSLayoutConstraint.activate([
            maleImageView.topAnchor.constraint(equalTo: malePercentContainer.topAnchor),
            maleImageView.leadingAnchor.constraint(equalTo: malePercentContainer.leadingAnchor),
            maleImageView.bottomAnchor.constraint(equalTo: malePercentContainer.bottomAnchor),
            maleImageView.widthAnchor.constraint(equalToConstant: 14)
        ])

        malePercentContainer.addSubview(maleLabel)
        NSLayoutConstraint.activate([
            maleLabel.leadingAnchor.constraint(equalTo: maleImageView.leadingAnchor),
            maleLabel.topAnchor.constraint(equalTo: malePercentContainer.topAnchor),
            maleLabel.trailingAnchor.constraint(equalTo: malePercentContainer.trailingAnchor),
            maleLabel.bottomAnchor.constraint(equalTo: malePercentContainer.bottomAnchor)
        ])

        genderContainer.addSubview(femalePercentContainer)
        NSLayoutConstraint.activate([
            femalePercentContainer.leadingAnchor.constraint(equalTo: malePercentContainer.trailingAnchor, constant: 14),
            femalePercentContainer.topAnchor.constraint(equalTo: genderContainer.topAnchor),
            femalePercentContainer.trailingAnchor.constraint(greaterThanOrEqualTo: femalePercentContainer.trailingAnchor, constant: 0),
            femalePercentContainer.bottomAnchor.constraint(equalTo: genderContainer.bottomAnchor),
            femalePercentContainer.widthAnchor.constraint(equalToConstant: 70)
        ])

        femalePercentContainer.addSubview(femaleImageView)
        NSLayoutConstraint.activate([
            femaleImageView.topAnchor.constraint(equalTo: femalePercentContainer.topAnchor),
            femaleImageView.leadingAnchor.constraint(equalTo: femalePercentContainer.leadingAnchor),
            femaleImageView.bottomAnchor.constraint(equalTo: femalePercentContainer.bottomAnchor),
            femaleImageView.widthAnchor.constraint(equalToConstant: 14)
        ])

        femalePercentContainer.addSubview(femaleLabel)
        NSLayoutConstraint.activate([
            femaleLabel.leadingAnchor.constraint(equalTo: femaleImageView.leadingAnchor),
            femaleLabel.topAnchor.constraint(equalTo: femalePercentContainer.topAnchor),
            femaleLabel.trailingAnchor.constraint(equalTo: femalePercentContainer.trailingAnchor),
            femaleLabel.bottomAnchor.constraint(equalTo: femalePercentContainer.bottomAnchor)
        ])

        // Egg Groups
        breedContainer.addSubview(eggGroupsContainer)
        NSLayoutConstraint.activate([
            eggGroupsContainer.topAnchor.constraint(equalTo: genderContainer.bottomAnchor, constant: 18),
            eggGroupsContainer.leadingAnchor.constraint(equalTo: breedContainer.leadingAnchor),
            eggGroupsContainer.trailingAnchor.constraint(equalTo: breedContainer.trailingAnchor),
            eggGroupsContainer.heightAnchor.constraint(equalToConstant: 16)
        ])

        eggGroupsContainer.addSubview(eggGroupsLabel)
        NSLayoutConstraint.activate([
            eggGroupsLabel.topAnchor.constraint(equalTo: eggGroupsContainer.topAnchor),
            eggGroupsLabel.leadingAnchor.constraint(equalTo: eggGroupsContainer.leadingAnchor),
            eggGroupsLabel.bottomAnchor.constraint(equalTo: eggGroupsContainer.bottomAnchor),
            eggGroupsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.breedSectionLabelWidth)
        ])

        eggGroupsContainer.addSubview(groupLabel)
        NSLayoutConstraint.activate([
            groupLabel.topAnchor.constraint(equalTo: eggGroupsContainer.topAnchor),
            groupLabel.leadingAnchor.constraint(equalTo: eggGroupsLabel.trailingAnchor, constant: 10),
            groupLabel.trailingAnchor.constraint(greaterThanOrEqualTo: eggGroupsContainer.trailingAnchor, constant: 0),
            groupLabel.bottomAnchor.constraint(equalTo: eggGroupsContainer.bottomAnchor)
        ])

        // Egg Cycle
        breedContainer.addSubview(eggCycleContainer)
        NSLayoutConstraint.activate([
            eggCycleContainer.topAnchor.constraint(equalTo: eggGroupsContainer.bottomAnchor, constant: 16),
            eggCycleContainer.leadingAnchor.constraint(equalTo: breedContainer.leadingAnchor),
            eggCycleContainer.trailingAnchor.constraint(equalTo: breedContainer.trailingAnchor),
            eggCycleContainer.bottomAnchor.constraint(equalTo: breedContainer.bottomAnchor),
            eggCycleContainer.heightAnchor.constraint(equalToConstant: 16)
        ])

        eggCycleContainer.addSubview(eggCycleLabel)
        NSLayoutConstraint.activate([
            eggCycleLabel.topAnchor.constraint(equalTo: eggCycleContainer.topAnchor),
            eggCycleLabel.leadingAnchor.constraint(equalTo: eggCycleContainer.leadingAnchor),
            eggCycleLabel.bottomAnchor.constraint(equalTo: eggCycleContainer.bottomAnchor),
            eggCycleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.breedSectionLabelWidth)
        ])

        eggCycleContainer.addSubview(cycleLabel)
        NSLayoutConstraint.activate([
            cycleLabel.topAnchor.constraint(equalTo: eggCycleContainer.topAnchor),
            cycleLabel.leadingAnchor.constraint(equalTo: eggCycleLabel.trailingAnchor, constant: 10),
            cycleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: eggCycleContainer.trailingAnchor, constant: 0),
            cycleLabel.bottomAnchor.constraint(equalTo: eggCycleContainer.bottomAnchor)
        ])
    }
}
