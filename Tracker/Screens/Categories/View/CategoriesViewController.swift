//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import UIKit

final class CategoriesViewController:
    UIViewController, PresentingViewController, BindableViewController, CategoriesViewControllerProtocol {
    
    // MARK: Views
    private lazy var categoriesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.register(
            ListItemCollectionViewCell.self,
            forCellWithReuseIdentifier: ListItemCollectionViewCell.reuseIdentifier
        )
        
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    private lazy var addCategoryButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        
        primaryButton.setTitle("Добавить категорию", for: .normal)
        primaryButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        return primaryButton
    }()
    private let emptyView: EmptyView = {
        let emptyView = EmptyView()
        
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.configure(
            image: .emptyTrackers,
            text: "Привычки и события можно объединить по смыслу"
        )
        
        return emptyView
    }()
    
    // MARK: Delegate
    private weak var delegate: CategoriesViewControllerDelegate?
    
    func configure(delegate: any CategoriesViewControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: BindableViewController
    typealias ViewModel = CategoriesViewModelProtocol
    var viewModel: ViewModel?
    
    func initialize(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        bind()
    }
    
    func bind() {
        viewModel?.onTrackerCategoriesStateChange = { [weak self] isEmptyTrackerCateogries in
            guard let self else { return }
            
            if isEmptyTrackerCateogries {
                presentEmptyView()
            } else {
                presentCategoriesCollectionView()
                categoriesCollectionView.reloadData()
            }
        }
        
        viewModel?.onSelectedTrackerCategoryStateChange = { [weak self] category in
            guard let self else { return }
            
            self.delegate?.categorySubmit(self, category: category)
        }
    }
    
    // MARK: Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSubviews()
        setupConstraints()
        
        viewModel?.viewDidLoad()
    }
    
    // MARK: PresentingViewController
    func setupView() {
        title = "Категория"
        
        view.backgroundColor = .trackerWhite
    }
    
    func setupSubviews() {
        view.addSubview(categoriesCollectionView)
        view.addSubview(addCategoryButton)
        view.addSubview(emptyView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            categoriesCollectionView.bottomAnchor.constraint(
                equalTo: addCategoryButton.topAnchor
            ),
            categoriesCollectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            categoriesCollectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            
            addCategoryButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            addCategoryButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20
            ),
            addCategoryButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20
            ),
            addCategoryButton.heightAnchor.constraint(
                equalToConstant: 60
            ),
            
            emptyView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor,
                constant: -76
            ),
            emptyView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            emptyView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16
            ),
        ])
    }
    
    // MARK: Methods
    private func presentEmptyView() {
        categoriesCollectionView.isHidden = true
        emptyView.isHidden = false
    }
    
    private func presentCategoriesCollectionView() {
        categoriesCollectionView.isHidden = false
        emptyView.isHidden = true
    }
    
    @IBAction private func submitButtonTapped() {
        viewModel?.addCategory()
    }
}

extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel?.catgoriesCount ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListItemCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        if let viewModel, let cell = cell as? ListItemCollectionViewCell {
            cell.configure(
                placement: .getPlacement(
                    at: indexPath.item,
                    in: viewModel.catgoriesCount
                )
            )
            cell.configure(title: viewModel.categoryName(at: indexPath))
            cell.configure(
                endAdorment: viewModel.isSelectedCategory(at: indexPath) ? .check : .none
            )
        }
        
        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 16, bottom: 0,right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: 75)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        viewModel?.selectCategory(at: indexPath)
    }
}
