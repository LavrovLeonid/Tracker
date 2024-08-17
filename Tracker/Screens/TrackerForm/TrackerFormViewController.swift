//
//  TrackerFormViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/5/24.
//

import UIKit

final class TrackerFormViewController: UIViewController, PresentingViewController, TrackerFormViewControllerProtocol {
    private var trackerType: TrackerType = .habit
    private weak var delegate: TrackerFormViewControllerDelegate?
    
    private var sections = TrackerFormViewControllerSections.allCases
    private let maxTrackerNameLength = 38
    private var showTrackerNameError = false
    private let textField = TrackerFormViewControllerTextField.allCases
    private var textFieldItemsCount: Int {
        showTrackerNameError ? textField.count : textField.count - 1
    }
    private let list = TrackerFormViewControllerListItems.allCases
    private var listItemsCount: Int {
        trackerType == .habit ? list.count : list.count - 1
    }
    private var trackerName = ""
    private var selectedCategoryName = "Важное"
    private var selectedWeekDays = Set<WeekDay>()
    private var selectedEmoji: String?
    private var selectedColor: TrackerColor?
    private let emoji = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", 
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    private let colors = TrackerColor.allCases
    
    private let formCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.register(
            DefaultHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DefaultHeaderReusableView.reuseIdentifier
        )
        collectionView.register(
            TextFieldCollectionViewCell.self,
            forCellWithReuseIdentifier: TextFieldCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            ErrorCollectionViewCell.self,
            forCellWithReuseIdentifier: ErrorCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            ListItemCollectionViewCell.self,
            forCellWithReuseIdentifier: ListItemCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        
        return collectionView
    }()
    private let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    private lazy var cancelButton: OutlineButton = {
        let outlineButton = OutlineButton()
        
        outlineButton.setTitle("Отменить", for: .normal)
        outlineButton.configure(color: .trackerRed)
        outlineButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return outlineButton
    }()
    private lazy var submitButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        
        primaryButton.setTitle("Создать", for: .normal)
        primaryButton.configure(isEnabled: false)
        primaryButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        return primaryButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    func configure(trackerType: TrackerType, delegate: TrackerFormViewControllerDelegate?) {
        self.trackerType = trackerType
        self.delegate = delegate
    }
    
    func setupView() {
        title = trackerType.title
        navigationItem.hidesBackButton = true
        isModalInPresentation = true
        
        view.backgroundColor = .trackerWhite
        
        formCollectionView.dataSource = self
        formCollectionView.delegate = self
    }
    
    func setupSubviews() {
        actionsStackView.addArrangedSubview(cancelButton)
        actionsStackView.addArrangedSubview(submitButton)
        
        view.addSubview(formCollectionView)
        view.addSubview(actionsStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            formCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            formCollectionView.bottomAnchor.constraint(equalTo: actionsStackView.topAnchor, constant: -16),
            formCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            formCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            actionsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            actionsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            actionsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            actionsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func presentScheduleViewController() {
        let scheduleViewController = ScheduleViewController()
        
        scheduleViewController.configure(
            initialSelectedWeekDays: selectedWeekDays,
            delegate: self
        )
        
        present(UINavigationController(rootViewController: scheduleViewController), animated: true)
    }
    
    private func isValidForm() -> Bool {
        guard !trackerName.isEmpty, trackerName.count <= maxTrackerNameLength else { return false }
        guard !selectedCategoryName.isEmpty else { return false }
        guard trackerType != .habit || !selectedWeekDays.isEmpty else { return false }
        guard selectedEmoji != nil else { return false }
        guard selectedColor != nil else { return false }
        
        return true
    }
    
    private func validateForm() {
        submitButton.configure(isEnabled: isValidForm())
    }
    
    @IBAction private func cancelButtonTapped() {
        delegate?.trackerFormCancel(self)
    }
    
    @IBAction private func submitButtonTapped() {
        guard let selectedColor, let selectedEmoji else { return }
        
        delegate?.trackerFormSubmit(
            self,
            trackerCategory: .init(
                name: selectedCategoryName,
                trackers: []
            ),
            tracker: .init(
                id: UUID(),
                type: trackerType,
                name: trackerName,
                color: selectedColor,
                emoji: selectedEmoji,
                schedules: selectedWeekDays
            )
        )
    }
}

extension TrackerFormViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
            case .name:
                textFieldItemsCount
            case .list:
                listItemsCount
            case .emoji:
                emoji.count
            case .colors:
                colors.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DefaultHeaderReusableView.reuseIdentifier,
            for: indexPath
        ) as? DefaultHeaderReusableView {
            switch sections[indexPath.section] {
                case .emoji:
                    cell.configure(with: "Emoji")
                    
                    return cell
                case .colors:
                    cell.configure(with: "Цвет")
                    
                    return cell
                default:
                    break
            }
        }
       
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            case .name:
                switch textField[indexPath.item] {
                    case .textField:
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: TextFieldCollectionViewCell.reuseIdentifier,
                            for: indexPath
                        )
                        
                        if let cell = cell as? TextFieldCollectionViewCell {
                            cell.configure(
                                text: trackerName,
                                placeholder: "Введите название трекера",
                                delegate: self
                            )
                        }
                        
                        return cell
                    case .error:
                        let cell = collectionView.dequeueReusableCell(
                            withReuseIdentifier: ErrorCollectionViewCell.reuseIdentifier,
                            for: indexPath
                        )
                        
                        if let cell = cell as? ErrorCollectionViewCell {
                            cell.configure(
                                error:
                                    "Ограничение \(maxTrackerNameLength) символ\(maxTrackerNameLength.getEnding(notMany: "а", many: "ов"))"
                            )
                        }
                        
                        return cell
                }
            case .list:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ListItemCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                
                if let cell = cell as? ListItemCollectionViewCell {
                    cell.configure(placement: .getPlacement(at: indexPath.item, in: listItemsCount))
                    cell.configure(endAdorment: .arrow)
                    
                    switch list[indexPath.item] {
                        case .categories:
                            cell.configure(
                                title: list[indexPath.item].title,
                                description: selectedCategoryName
                            )
                        case .schedule:
                            cell.configure(
                                title: list[indexPath.item].title,
                                description: WeekDay.getSorted(by: selectedWeekDays).map { $0.short }.joined(separator: ", ")
                            )
                    }
                }
                
                return cell
            case .emoji:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EmojiCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                
                if let cell = cell as? EmojiCollectionViewCell {
                    let emoji = emoji[indexPath.item]
                    
                    cell.configure(emoji: emoji, isSelected: selectedEmoji == emoji)
                }
                
                return cell
            case .colors:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                    for: indexPath
                )
                
                if let cell = cell as? ColorCollectionViewCell {
                    let color = colors[indexPath.item]
                    
                    cell.configure(color: color.uiColor, isSelected: selectedColor == color)
                }
                
                return cell
        }
    }
}

extension TrackerFormViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        switch sections[section] {
            case .emoji, .colors:
                CGSize(width: collectionView.frame.width, height: 18)
            default:
                    .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        switch sections[section] {
            case .name:
                UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16)
            case .list:
                UIEdgeInsets(top: 12,left: 18,bottom: 32,right: 18)
            case .emoji:
                UIEdgeInsets(top: 16,left: 18,bottom: 40,right: 18)
            case .colors:
                UIEdgeInsets(top: 16,left: 18,bottom: 24,right: 18)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        switch sections[section] {
            case .emoji:
                5
            default:
                    .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch sections[indexPath.section] {
            case .name:
                switch textField[indexPath.item] {
                    case .textField:
                        CGSize(width: collectionView.frame.width - 32, height: 75)
                    case .error:
                        CGSize(width: collectionView.frame.width - 32, height: 22)
                }
            case .list:
                CGSize(width: collectionView.frame.width - 32, height: 75)
            case .emoji, .colors:
                CGSize(width: 52, height: 52)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        switch sections[section] {
            case .name:
                8
            default:
                    .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
            case .list:
                switch list[indexPath.item] {
                    case .categories:
                        break
                    case .schedule:
                        presentScheduleViewController()
                }
            case .emoji:
                var previousIndexPath: IndexPath?
                
                if let selectedEmoji, let previousIndex = emoji.firstIndex(of: selectedEmoji) {
                    previousIndexPath = IndexPath(item: previousIndex, section: indexPath.section)
                }
                
                selectedEmoji = emoji[indexPath.item]
                validateForm()
                
                if let previousIndexPath {
                    collectionView.reloadItems(at: [previousIndexPath, indexPath])
                } else {
                    collectionView.reloadItems(at: [indexPath])
                }
            case .colors:
                var previousIndexPath: IndexPath?
                
                if let selectedColor, let previousIndex = colors.firstIndex(of: selectedColor) {
                    previousIndexPath = IndexPath(item: previousIndex, section: indexPath.section)
                }
                
                selectedColor = colors[indexPath.item]
                validateForm()
                
                if let previousIndexPath {
                    collectionView.reloadItems(at: [previousIndexPath, indexPath])
                } else {
                    collectionView.reloadItems(at: [indexPath])
                }
            default:
                break
        }
    }
}

extension TrackerFormViewController: TextFieldCollectionViewCellDelegate {
    func textFieldChangeValue(_ cell: TextFieldCollectionViewCell, with value: String) {
        trackerName = value
        
        let hasNameError = value.count > maxTrackerNameLength
        
        if hasNameError != showTrackerNameError {
            showTrackerNameError = hasNameError
            
            if hasNameError {
                formCollectionView.insertItems(at: [
                    IndexPath(
                        item: TrackerFormViewControllerTextField.error.rawValue,
                        section: TrackerFormViewControllerSections.name.rawValue
                    )
                ])
            } else {
                formCollectionView.deleteItems(at: [
                    IndexPath(
                        item: TrackerFormViewControllerTextField.error.rawValue,
                        section: TrackerFormViewControllerSections.name.rawValue
                    )
                ])
            }
        }
        
        validateForm()
    }
}

extension TrackerFormViewController: ScheduleViewControllerDelegate {
    func scheduleSubmit(_ viewController: ScheduleViewControllerProtocol, selectedWeekDays: Set<WeekDay>) {
        guard self.selectedWeekDays != selectedWeekDays else {
            viewController.dismiss(animated: true)
            
            return
        }
        
        self.selectedWeekDays = selectedWeekDays
        
        validateForm()
        
        let indexPath = IndexPath(
            item: TrackerFormViewControllerListItems.schedule.rawValue,
            section: TrackerFormViewControllerSections.list.rawValue
        )
        
        viewController.dismiss(animated: true) { [weak self] in
            self?.formCollectionView.reloadItems(at: [indexPath])
        }
    }
}
