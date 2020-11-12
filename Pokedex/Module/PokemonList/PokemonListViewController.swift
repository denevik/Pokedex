import PokedexAPI
import PokedexStyle

class PokemonListViewController: UIViewController, UISearchControllerDelegate {

    private lazy var viewModel: PokemonListViewModelProtocol = {
        PokemonListViewModel()
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .white

        return collectionView
    }()

    private lazy var loadingIndication: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        return activityIndicator
    }()

    private let search = UISearchController(searchResultsController: nil)

    // Please, use IPhone 11 Pro for better appearance
    // because lots of "magic numbers"
    // and not many scaling calculations according to the screen size
    //
    // Thank you!
    //
    // P.s. I did remove cell loading indicator + status
    // (e.g. loading, finished, error) because it was not finished

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        setupNavigationController()
        setupCollectionView()
        setupActivityIndicator()
        showLoadingIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}

extension PokemonListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pokemonItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.reuseIdentifier, for: indexPath) as! PokemonCollectionViewCell

        cell.configure(with: viewModel.pokemonItems[indexPath.row])

        return cell
    }
}

extension PokemonListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: PokemonCollectionViewCell.Constants.width, height: PokemonCollectionViewCell.Constants.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemonItem = viewModel.pokemonItems[indexPath.row]
        guard let pokemon = viewModel.pokemonDetails(name: pokemonItem.name) else { return }

        let pokemonDetailsViewModel = PokemonDetailsViewModel(pokemon: pokemon, pokemonImage: pokemonItem.image)
        let pokemonDetailsViewController = PokemonDetailsViewController(viewModel: pokemonDetailsViewModel)
        navigationController?.pushViewController(pokemonDetailsViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Quick alternative of prefetchItemsAt
        if indexPath.row == viewModel.pokemonItems.count - 60 {
            viewModel.loadMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: PokemonCollectionViewCell.Constants.leftInset,
                            bottom: PokemonCollectionViewCell.Constants.leftInset,
                            right: PokemonCollectionViewCell.Constants.rightInset)
    }
}

// MARK: - PokemonListViewModelDelegate

extension PokemonListViewController: PokemonListViewModelDelegate {

    func didFinishPageLoading() {
        // We can do batchUpdates but it would be better
        // to combine it with Operation + Queue
        hideLoadingIndicator()
        collectionView.reloadData()
    }

    func filterDidUpdate() {
        collectionView.reloadData()
    }
}

// MARK: - Search Bar

extension PokemonListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty {
            viewModel.filter = text
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filter = ""
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// MARK: - PokemonListViewController Private

private extension PokemonListViewController {

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.reuseIdentifier)
    }

    func setupNavigationController() {
        title = "Pokedex"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let backArrowWithInsets = UIImage(named: "backArrow")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0))
        navigationController?.navigationBar.backIndicatorImage = backArrowWithInsets
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrowWithInsets
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationItem.searchController = search
        navigationItem.searchController?.searchBar.placeholder = "Search Pokemon, e.g. Pikachu"
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }

    func setupActivityIndicator() {
        view.addSubview(loadingIndication)
        NSLayoutConstraint.activate([
            loadingIndication.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndication.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // We can do extra actions for animations
    // this is why I used separate functions
    // But due to time limit leave it as is
    func showLoadingIndicator() {
        loadingIndication.startAnimating()
    }

    func hideLoadingIndicator() {
        if loadingIndication.isAnimating {
            loadingIndication.stopAnimating()
        }
    }
}
