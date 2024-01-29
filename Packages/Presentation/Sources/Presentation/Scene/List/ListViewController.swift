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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPrompt))
                self.navigationItem.rightBarButtonItem = addButton
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
            <SectionType, WordType>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath, item: WordType) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
            cell.textLabel?.text = item
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }

    func configureSnapshot() {
        snapshot = .init()
        snapshot.appendSections([.favorites, .main])
    }
    @objc func showPrompt() {
            // Create an alert controller
            let alertController = UIAlertController(title: "Enter String", message: nil, preferredStyle: .alert)

            // Add a text field to the alert controller
            alertController.addTextField { textField in
                textField.placeholder = "Enter your string"
            }

            // Create a "Submit" action
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
                // Handle the submission of the entered string
                if let enteredString = alertController.textFields?.first?.text {
                    self?.handleSubmission(enteredString)
                }
            }

            // Add the "Submit" action to the alert controller
            alertController.addAction(submitAction)

            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }
    func handleSubmission(_ enteredString: String) {
            // Handle the submitted string, for example, print it
        viewModel.add(word: enteredString)
            // You can perform any further actions with the entered string here
        }
    func bind() {
        viewModel.page
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self, case .loaded(let result) = $0 else { return }
                snapshot.appendItems(result, toSection: .main)
                dataSource.apply(snapshot, animatingDifferences: true)
            }.store(in: &cancellables)

        viewModel.clear
            .sink { [weak self] _ in
                self?.snapshot.deleteAllItems()
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
                    snapshot.appendItems([$0.item], toSection: .favorites)
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
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.cellWillDisplay(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(word: dataSource.itemIdentifier(for: indexPath)!)
    }
}
