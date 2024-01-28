//
//  ListViewController.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Combine
import DI
import Domain
import UIKit

final class ListViewController: UIViewController {
    fileprivate enum Section {
        case favorites
        case main
    }

    @Inject(container: .viewModels) private var viewModel: ListViewModel

    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UITableViewDiffableDataSource<Section, WordType>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, WordType>!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.viewDidLoad()
    }
}

fileprivate extension ListViewController {
    func configure() {
        configureNavigation()
        configureTableView()
        configureDataSource()
        configureSnapshot()
        bind()
    }

    func configureNavigation() {
        title = "List"
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource
            <Section, WordType>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath, item: WordType) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
            cell.textLabel?.text = item
            return cell
        }
        self.dataSource.defaultRowAnimation = .fade
    }

    func configureSnapshot() {
        snapshot = .init()
        snapshot.appendSections([.favorites, .main])
    }

    func bind() {
        viewModel.page
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self, case .loaded(let result) = $0 else { return }
                snapshot.appendItems(result)
                dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)

        viewModel.clear
            .sink { [weak self] _ in
                self?.snapshot.deleteAllItems()
            }.store(in: &cancellables)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.cellWillDisplay(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // viewModel.didSelectItemAt(at: indexPath.row)
    }
}
