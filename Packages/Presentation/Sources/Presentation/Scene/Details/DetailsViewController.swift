//
//  DetailsViewController.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI
import Combine
import UIKit

class DetailsViewController: UIViewController {
    @Inject(container: .viewModels) var viewModel: DetailsViewModel
    private var cancellable: AnyCancellable?

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        return toggleSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        // Add UI elements to the view
        view.addSubview(label)
        view.addSubview(removeButton)
        view.addSubview(toggleSwitch)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            removeButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            
            toggleSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleSwitch.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: 20)
        ])

        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }

    private func bindViewModel() {
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchDidChange), for: .valueChanged)
        label.text = viewModel.word
        cancellable = viewModel.info
            .sink { [weak self] in
                guard let self, case .loaded(let result) = $0 else { return }
                print(result.count)
                label.text = "\(label.text ?? ""): \(result.count)"
                toggleSwitch.isOn = result.favorite
            }
    }

    @objc private func removeButtonTapped() {
        viewModel.remove()
    }

    @objc private func toggleSwitchDidChange() {
        viewModel.favorite(isOn: toggleSwitch.isOn)
    }
}
