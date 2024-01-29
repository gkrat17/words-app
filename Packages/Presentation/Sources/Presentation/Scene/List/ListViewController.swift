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
    @Inject(container: .viewModels) private var viewModel: ListViewModel

    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UITableViewDiffableDataSource<SectionType, WordType>!
    private var snapshot: NSDiffableDataSourceSnapshot<SectionType, WordType>!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configure()
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
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(alert))
        navigationItem.rightBarButtonItem = button
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource
            <SectionType, WordType>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath, item: WordType) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
            cell.textLabel?.text = item
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }

    func configureSnapshot() {
        snapshot = .init()
        snapshot.appendSections([.favorites, .nonfavorites])
    }

    func bind() {
        viewModel.page
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self, case .loaded(let result) = $0 else { return }
                snapshot.appendItems(result, toSection: .nonfavorites)
                dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)

        viewModel.replace
            .sink { [weak self] in
                guard let self else { return }
                snapshot.deleteItems([$0.item])
                if let neighbor = $0.neighbor {
                    switch neighbor {
                    case .after(let neighbor):
                        snapshot.insertItems([$0.item], afterItem: neighbor)
                    case .before(let neighbor):
                        snapshot.insertItems([$0.item], beforeItem: neighbor)
                    }
                } else {
                    snapshot.appendItems([$0.item], toSection: $0.section)
                }
                dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)

        viewModel.remove
            .sink { [weak self] in
                guard let self else { return }
                snapshot.deleteItems([$0])
                dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)
    }

    @objc func alert() {
        let alert = UIAlertController(title: "Enter word", message: nil, preferredStyle: .alert)

        alert.addTextField {
            $0.placeholder = "Enter word"
        }

        let action = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let word = alert.textFields?.first?.text {
                self?.viewModel.add(word: word)
            }
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.cellWillDisplay(at: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(word: dataSource.itemIdentifier(for: indexPath)!)
    }
}
