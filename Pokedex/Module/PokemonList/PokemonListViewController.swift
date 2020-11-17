import PokedexAPI
import PokedexStyle

class PokemonListViewController: UIViewController, UISearchControllerDelegate {

    fileprivate struct Constants {

        // Back arrow for navigation controller
        static let backArrorIconName = "backArrow"
        static let backArrowEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)

        // Collection view cell
        static let collectionViewCellWidth = 155
        static let collectionViewCellHeight = 111
        static let collectionViewCellTopInset: CGFloat = 0
        static let collectionViewCellLeftInset: CGFloat = 25
        static let collectionViewCellRightInset: CGFloat = 25
        static let collectionViewCellBottomInset: CGFloat = 25

        // Search error label
        static let searchErrorLabelFontSize: CGFloat = 18
        static let searchErrorLabelAlpha: CGFloat = 0.4
        static let searchErrorLabelTopConstant: CGFloat = 20
        static let searchErrorLabelHeightConstant: CGFloat = 18

        // Loading indicator
        static let loadingIndicatorTopConstant: CGFloat = 30

        // Navigation controller
        static let navigationControllerTitle = "Pokedex"
        static let navigationControllerSearchBarPlaceholder = "Search Pokemon, e.g. Pikachu"
    }

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

    private var searchTimer: Timer?

    private lazy var searchErrorLabel: UILabel = {
        let label = UILabel()
        label.font = Font.circularStdBook.uiFont(Constants.searchErrorLabelFontSize)
        label.textAlignment = .center
        label.textColor = UIColor.black.withAlphaComponent(Constants.searchErrorLabelAlpha)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: searchController.searchBar.frame.height + (navigationController?.navigationBar.frame.height ?? 0.0) + Constants.searchErrorLabelTopConstant),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: Constants.searchErrorLabelHeightConstant)
        ])

        return label
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .gray

        return activityIndicator
    }()

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        setupNavigationController()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.tintColor = UIColor.systemBlue
        }
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
        CGSize(width: Constants.collectionViewCellWidth, height: Constants.collectionViewCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemonItem = viewModel.pokemonItems[indexPath.row]
        guard let pokemon = viewModel.pokemonDetails(name: pokemonItem.name) else {
            return
        }

        let pokemonDetailsViewModel = PokemonDetailsViewModel(pokemon: pokemon)
        let pokemonDetailsViewController = PokemonDetailsViewController(viewModel: pokemonDetailsViewModel)
        navigationController?.pushViewController(pokemonDetailsViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.collectionViewCellTopInset,
                            left: Constants.collectionViewCellLeftInset,
                            bottom: Constants.collectionViewCellBottomInset,
                            right: Constants.collectionViewCellRightInset)
    }
}

extension PokemonListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(IndexPath(row: viewModel.pokemonItems.count - 1, section: 0)) {
            viewModel.loadMore()
        }
    }
}

// MARK: - PokemonListViewModelDelegate

extension PokemonListViewController: PokemonListViewModelDelegate {
    func searchDidFinish(status: SearchStatus) {
        hideLoadingIndicator()

        switch status {
        case .notEnoughLetters:
            searchErrorLabel.text = status.rawValue
            showSearchError()
        case .noMatch:
            searchErrorLabel.text = status.rawValue
            showSearchError()
        case .requestIssue:
            searchErrorLabel.text = status.rawValue
            showSearchError()
        case .emptySearch, .success:
            hideSearchError()
            collectionView.reloadData()
        }
    }

    func dataSourceDidUpdate() {
        collectionView.reloadData()
    }

    func didFinishLoadingPokemon(_ id: Int) {
        performBatchUpdates(for: id - 1)
    }
}

// MARK: - Search Bar

extension PokemonListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDidUpdate(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            searchDidUpdate(with: text)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchDidUpdate(with: searchBar.text!)
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

        collectionView.prefetchDataSource = self
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.reuseIdentifier)
    }

    func setupNavigationController() {
        title = Constants.navigationControllerTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let backArrowWithInsets = UIImage(named: Constants.backArrorIconName)?.withAlignmentRectInsets(Constants.backArrowEdgeInsets)
        navigationController?.navigationBar.backIndicatorImage = backArrowWithInsets
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrowWithInsets
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = Constants.navigationControllerSearchBarPlaceholder
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        view.backgroundColor = .white
    }

    func showLoadingIndicator() {
        if !loadingIndicator.isDescendant(of: view) && !loadingIndicator.isAnimating {
            view.addSubview(loadingIndicator)
            NSLayoutConstraint.activate([
                loadingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.loadingIndicatorTopConstant + searchErrorLabel.frame.height),
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
            loadingIndicator.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }

    func performBatchUpdates(for index: Int) {
        if viewModel.pokemonItems.indices.contains(index) {
            collectionView.performBatchUpdates {
                collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }

    func searchDidUpdate(with text: String) {
        hideSearchError()
        showLoadingIndicator()
        viewModel.searchPokemon(name: text.lowercased())
    }

    func showSearchError() {
        collectionView.isHidden = true
        searchErrorLabel.isHidden = false
    }

    func hideSearchError() {
        searchErrorLabel.isHidden = true
        collectionView.isHidden = false
    }
}
