//
//  CategoryListViewController.swift
//  Tracker
//
//  Created by Nikita Khon on 20.06.2025.
//

import UIKit

final class CategoryListViewController: UIViewController {
    
    // MARK: - Visual Components
    
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .star
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.numberOfLines = 0
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private lazy var categoriesTableView: AutoHeightTableView = {
        let tableView = AutoHeightTableView()
        tableView.dataSource = self
        tableView.delegate = self
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
    
    // MARK: - Public Properties
    
    var viewModel: CategoryListViewModel?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel?.onViewDidLoad()
    }
    
    // MARK: - Actions
    
    @objc private func addCategoryButtonTapped() {
        viewModel?.routeToCategoryEditor()
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
        view.addSubviews(infoImageView, infoLabel, categoriesTableView, addCategoryButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            infoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 8),
            infoLabel.centerXAnchor.constraint(equalTo: infoImageView.centerXAnchor)
        ])
        
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
        viewModel?.categoriesBinding = { [weak self] categories in
            guard let self else { return }
            self.categoriesTableView.reloadData()
            
            let isHidden = categories.isEmpty
            infoImageView.isHidden = !isHidden
            infoLabel.isHidden = !isHidden
            categoriesTableView.isHidden = isHidden
        }
        
        viewModel?.tableSelectBinding = { [weak self] indexPath in
            guard let self else { return }
            self.categoriesTableView.deselectRow(at: indexPath, animated: true)
            self.categoriesTableView.reloadRows(at: [indexPath], with: .automatic)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dismiss(animated: true)
            }
        }
        
        viewModel?.tableDeselectBinding = { [weak self] indexPath in
            guard let self else { return }
            self.categoriesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        viewModel?.tableDeleteAttempyBinding = { [weak self] indexPath in
            guard let self else { return }
            
            let alert = UIAlertController(
                title: "Эта категория точно не нужна?",
                message: nil,
                preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(
                title: "Удалить",
                style: .destructive
            ) { _ in
                self.viewModel?.deleteCell(at: indexPath)
            }
            alert.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension CategoryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoryCell.identifier,
                for: indexPath) as? CategoryCell,
            let viewModel = viewModel?.categories[indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectCell(at: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil
        ) { _ in
            let editAction = UIAction(title: "Редактировать") { [weak self] _ in
                guard let self else { return }
                self.viewModel?.editCell(at: indexPath)
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                attributes: .destructive
            ) { [weak self] _ in
                guard let self else { return }
                self.viewModel?.didAttempToDeleteCell(at: indexPath)
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}
