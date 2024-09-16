//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/7/24.
//

import UIKit

final class OnboardingViewController: UIPageViewController, PresentingViewController, OnboardingViewControllerProtocol {
    private lazy var pages: [UIViewController] = {
        let firstPage = OnboardingPageViewController()
        
        firstPage.configure(
            backgroundImage: .onboardingFirstBackground,
            text: "Отслеживайте только то, что хотите"
        )

        let secondPage = OnboardingPageViewController()
        
        secondPage.configure(
            backgroundImage: .onboardingSecondBackground,
            text: "Даже если это не литры воды и йога"
        )

        return [firstPage, secondPage]
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .onboardingPrimary
        pageControl.pageIndicatorTintColor = .onboardingPrimary.withAlphaComponent(0.3)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        
        return pageControl
    }()
    private lazy var actionButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        
        primaryButton.setTitle("Вот это технологии!", for: .normal)
        primaryButton.backgroundColor = .onboardingPrimary
        primaryButton.setTitleColor(.onboardingSecondary, for: .normal)
        primaryButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return primaryButton
    }()
    
    weak var onboardingDelegate: OnboardingViewControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    func configure(delegate: OnboardingViewControllerDelegate) {
        onboardingDelegate = delegate
    }
    
    func setupView() {
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
    }
    
    func setupSubviews() {
        view.addSubview(pageControl)
        view.addSubview(actionButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -24),
            
            actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    @IBAction private func pageControlValueChanged(_ sender: UIPageControl) {
        guard let currentIndex = getCurrentIndex() else { return }
        
        setViewControllers(
            [pages[sender.currentPage]],
            direction: sender.currentPage > currentIndex ? .forward : .reverse,
            animated: true
        )
    }
    
    @IBAction private func actionButtonTapped() {
        guard let currentIndex = getCurrentIndex() else { return }
        
        let nextIndex = currentIndex + 1
        
        if nextIndex == pages.count {
            onboardingDelegate?.onboardingDidComplete(self)
        } else {
            setViewControllers([pages[nextIndex]], direction: .forward, animated: true)
            pageControl.currentPage = nextIndex
        }
    }
    
    private func getCurrentIndex() -> Int? {
        guard let currentViewController = viewControllers?.first else { return nil }
        
        return pages.firstIndex(of: currentViewController)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        return previousIndex >= 0 ? pages[previousIndex] : nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        return nextIndex < pages.count ? pages[nextIndex] : nil
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let currentIndex = getCurrentIndex() else { return }
        
        pageControl.currentPage = currentIndex
    }
}
