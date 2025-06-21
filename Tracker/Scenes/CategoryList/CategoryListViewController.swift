//
//  CategoryListViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 20.06.2025.
//

import UIKit

final class CategoryListViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var categoriesTableView: AutoHeightTableView = {
        let tableView = AutoHeightTableView()
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private Methods
    
    private let viewModel: CategoryListViewModel
    
    // MARK: - Initializers
    
    init(viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Actions
    
    @objc private func addCategoryButtonTapped() {
        
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        title = "Категория"
        view.backgroundColor = .ypWhite
        
        addSubviews()
        addConstraints()
        addBindings()
    }
    
    private func addSubviews() {
        view.addSubviews(categoriesTableView, addCategoryButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            addCategoryButton.topAnchor.constraint(greaterThanOrEqualTo: categoriesTableView.bottomAnchor, constant: 24),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addBindings() {
        viewModel.categoriesBinding = { [weak self] _ in
            guard let self else { return }
            self.categoriesTableView.reloadData()
        }
    }
}

extension CategoryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.identifier,
            for: indexPath) as? CategoryCell
        else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel.categories[indexPath.row]
        return cell
    }
}
