//
//  DetailsViewController.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI
import Domain
import Combine
import UIKit

final class DetailsViewController: UIViewController {
    @Inject(container: .viewModels) private var viewModel: DetailsViewModel

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()

    private let word = UILabel()
    private let count = UILabel()
    private let favorite = UISwitch()

    private let add: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        return button
    }()

    private let delete: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        return button
    }()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.viewDidLoad()
    }

    func configure() {
        configureUI()
        bind()
    }

    func configureUI() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(word)
        stackView.addArrangedSubview(count)
        stackView.addArrangedSubview(favorite)
        stackView.addArrangedSubview(add)
        stackView.addArrangedSubview(delete)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func bind() {
        viewModel.word
            .sink { [weak self] in
                self?.word.text = $0
            }.store(in: &cancellables)

        viewModel.count
            .sink { [weak self] in
                self?.count.text = "Count: \($0)"
            }.store(in: &cancellables)

        viewModel.favorite
            .sink { [weak self] in
                self?.favorite.isOn = $0
            }.store(in: &cancellables)

        viewModel.isEnabledAdd
            .sink { [weak self] in
                self?.add.isEnabled = $0
            }.store(in: &cancellables)

        viewModel.isEnabledDelete
            .sink { [weak self] in
                self?.delete.isEnabled = $0
            }.store(in: &cancellables)

        add.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        delete.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        favorite.addTarget(self, action: #selector(favoriteToggled), for: .valueChanged)
    }

    @objc func addTapped() {
        viewModel.add()
    }

    @objc func deleteTapped() {
        viewModel.delete()
    }

    @objc func favoriteToggled() {
        viewModel.favorite(isOn: favorite.isOn)
    }

    func set(word: WordType) {
        viewModel.set(word: word)
    }
}
