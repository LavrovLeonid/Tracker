//
//  CategoryFormViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/9/24.
//

import UIKit

final class CategoryFormViewController:
    UIViewController, PresentingViewController, BindableViewController, CategoryFormViewControllerProtocol {
    // MARK: Views
    private lazy var categoryNameTextField: TextField = {
        let textField = TextField()
        
        textField.placeholder = "Введите название категории"
        textField.clearButtonMode = .whileEditing
        textField.addTarget(
            self,
            action: #selector(categoryNameChange(_:)),
            for: .editingChanged
        )
        textField.delegate = self
        
        return textField
    }()
    private lazy var submitButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        
        primaryButton.setTitle("Готово", for: .normal)
        primaryButton.addTarget(
            self,
            action: #selector(submitButtonTapped),
            for: .touchUpInside
        )
        
        return primaryButton
    }()
    
    // MARK: BindableViewController
    typealias ViewModel = CategoryFormViewModelProtocol
    var viewModel: ViewModel?
    
    func initialize(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        bind()
    }
    
    func bind() {
        viewModel?.onEnableSubmitButtonStateChange = { [weak self] isEnabledCreateCategory in
            self?.setEnabledSubmitButton(isEnabledCreateCategory)
        }
        
        viewModel?.onIsNewCategoryStateChange = { [weak self] isNewCategory in
            self?.setTitle(isNewCategory)
        }
        
        viewModel?.onInitialCategoryNameStateChange = { [weak self] categoryName in
            self?.categoryNameTextField.text = categoryName
        }
        
        viewModel?.onCategorySubmit = { [weak self] category in
            guard let self, let delegate else { return }
            
            delegate.submitCategory(self, category: category)
        }
    }
    
    // MARK: Delegate
    private weak var delegate: CategoryFormViewControllerDelegate?
    
    func configure(delegate: any CategoryFormViewControllerDelegate) {
        self.delegate = delegate
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
        setTitle()
        
        view.backgroundColor = .trackerWhite
        navigationItem.hidesBackButton = true
    }
    
    func setupSubviews() {
        view.addSubview(categoryNameTextField)
        view.addSubview(submitButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryNameTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24
            ),
            categoryNameTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16
            ),
            categoryNameTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16
            ),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            submitButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16
            ),
            submitButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20
            ),
            submitButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20
            ),
            submitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: Methods
    private func setTitle(_ isNewCategory: Bool = false) {
        title = isNewCategory ? "Новая категория" : "Редактирование категории"
    }
    
    private func setEnabledSubmitButton(_ isEnabled: Bool) {
        submitButton.configure(isEnabled: isEnabled)
    }
    
    @IBAction private func categoryNameChange(_ sender: TextField) {
        viewModel?.changeCategoryName(sender.text ?? "")
    }
    
    @IBAction private func submitButtonTapped() {
        viewModel?.submit()
    }
}

extension CategoryFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return false
    }
}
