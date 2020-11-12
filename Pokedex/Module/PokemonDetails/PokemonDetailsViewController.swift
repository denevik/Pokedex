import PokedexStyle

class PokemonDetailsViewController: UIViewController {

    private var viewModel: PokemonDetailsViewModelProtocol
    private let screenSize: CGRect = UIScreen.main.bounds

    private lazy var pokemonIdLabel: PokemonIdLabel = {
        let pokemonLabelId = PokemonIdLabel(id: viewModel.pokemon.id)
        pokemonLabelId.font = Font.circularStdBlack.uiFont(18)
        pokemonLabelId.translatesAutoresizingMaskIntoConstraints = false

        return pokemonLabelId
    }()

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

    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(23)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "About"
        label.textAlignment = .center

        return label
    }()

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
        view.backgroundColor = .clear

        return view
    }()

    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(16)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Height"

        return label
    }()

    private lazy var heightValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(viewModel.pokemon.height * 10) cm"

        return label
    }()

    // Weight

    private lazy var weightContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear

        return view
    }()

    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(16)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Weight"

        return label
    }()

    private lazy var weightValueLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(viewModel.pokemon.weight / 10) kg"

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

        // About label
        infoCardBackgroundView.addSubview(aboutLabel)
        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(equalTo: infoCardBackgroundView.topAnchor, constant: 46),
            aboutLabel.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: 27),
            aboutLabel.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: -27),
        ])

        // Pokemon image view
        infoCardBackgroundView.addSubview(pokemonImageView)
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: infoCardBackgroundView.topAnchor, constant: -(screenSize.height * 30 / 100) * 0.7),
            pokemonImageView.centerXAnchor.constraint(equalTo: infoCardBackgroundView.centerXAnchor),
            pokemonImageView.heightAnchor.constraint(equalToConstant:  (screenSize.height * 30 / 100)),
            pokemonImageView.widthAnchor.constraint(equalToConstant: (screenSize.width * 50) / 100)
        ])

        // Height and weight
        infoCardBackgroundView.addSubview(bodyStatsView)
        NSLayoutConstraint.activate([
            bodyStatsView.topAnchor.constraint(equalTo: aboutLabel.topAnchor, constant: 50),
            bodyStatsView.leadingAnchor.constraint(equalTo: infoCardBackgroundView.leadingAnchor, constant: 28),
            bodyStatsView.trailingAnchor.constraint(equalTo: infoCardBackgroundView.trailingAnchor, constant: -27),
            bodyStatsView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Height
        heightContainerView.addSubview(heightLabel)
        NSLayoutConstraint.activate([
            heightLabel.topAnchor.constraint(equalTo: heightContainerView.topAnchor),
            heightLabel.leadingAnchor.constraint(equalTo: heightContainerView.leadingAnchor),
            heightLabel.trailingAnchor.constraint(equalTo: heightContainerView.trailingAnchor),
            heightLabel.heightAnchor.constraint(equalToConstant: 20)
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
            heightContainerView.leadingAnchor.constraint(equalTo: bodyStatsView.leadingAnchor, constant: 75),
            heightContainerView.bottomAnchor.constraint(equalTo: bodyStatsView.bottomAnchor, constant: -17),
            heightContainerView.widthAnchor.constraint(equalToConstant: 72)
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
            weightContainerView.trailingAnchor.constraint(equalTo: bodyStatsView.trailingAnchor, constant: -40),
            weightContainerView.leadingAnchor.constraint(equalTo: heightContainerView.trailingAnchor, constant: 45),
            weightContainerView.bottomAnchor.constraint(equalTo: bodyStatsView.bottomAnchor, constant: -17)
        ])
    }
}
