//
//  SheetController.swift
//  TNChart
//
//  Created by Dmitriy Safarov on 21.05.2021.
//

import Foundation
import SnapKit
import UIKit
import Hero

class SheetController: UIViewController {
    
    // MARK: - UI Variables
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = TNChartConfiguration.chartAppearance.sheet.sheetContainerBackgroundColor
        view.addSubview(containerView)
        return containerView
    }()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.backgroundColor = TNChartConfiguration.chartAppearance.sheet.backgroundViewBackgroundColor
        view.addSubview(backgroundView)
        return backgroundView
    }()
    
    private lazy var pulleyView: UIView = {
        let pulleyView = UIView()
        pulleyView.backgroundColor = TNChartConfiguration.chartAppearance.sheet.pulleyBackgroundColor
        pulleyView.layer.cornerRadius = 2.5
        view.addSubview(pulleyView)
        return pulleyView
    }()
    
    // MARK: - Variables
    
    private var dismissHandler: (() -> Void)?
    
    private var settings: SheetControllerSettings = SheetControllerSettings.defaultSettings()
    
    fileprivate var isPresenting = false
    var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return view.safeAreaInsets
        }
        return .zero
    }
    
    // MARK: - Constructors
    
    init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
        setupConstraints()
        settings.animation.scale = nil
        settings.animation.present.duration = 0.6
        settings.animation.dismiss.duration = 0.5
        settings.animation.dismiss.options = .curveEaseIn
        settings.animation.dismiss.offset = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    /// Rotate chart 90 degrees
    private func rotateIfNeed() {
        let currentOrientation = UIDevice.current.orientation
        let supportedOrientations: [UIDeviceOrientation]  = [.landscapeLeft, .landscapeRight]
        guard supportedOrientations.contains(currentOrientation) else { return }
        self.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0 * UIDevice.current.orientation.rotationSign)
        self.view.hero.modifierString = "rotate(" + (currentOrientation.contrRotationSignString) + "1.57)"
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.height, height: self.view.frame.width)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateIfNeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        backgroundView.addGestureRecognizer(tap)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipeDown.direction = .down
        backgroundView.addGestureRecognizer(swipeDown)
        
        let swipeDownHeader = UISwipeGestureRecognizer(target: self, action: #selector(close))
        swipeDownHeader.direction = .down
        backgroundView.addGestureRecognizer(swipeDownHeader)
    }
    
    // MARK: - OBJC Functions
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
        dismissHandler?()
    }
    
    // MARK: - Private Functions
    
    func dismiss(_ completion: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true) {
            completion?()
        }
    }
    
    func setupConstraints() {
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        pulleyView.snp.makeConstraints { (make) in
            make.height.equalTo(5)
            make.width.equalTo(42)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(containerView.snp.top).offset(-8)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
    }
    
}

extension SheetController: UIViewControllerTransitioningDelegate {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if settings.animation.scale != nil {
            presentingViewController?.view.transform = CGAffineTransform.identity
        }
        coordinator.animate(alongsideTransition: { [weak self] _ in
            if let scale = self?.settings.animation.scale {
                self?.presentingViewController?.view.transform = CGAffineTransform(scaleX: scale.width, y: scale.height)
            }
            }, completion: nil)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? 0 : settings.animation.dismiss.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let transitionContainerView = transitionContext.containerView
        guard let fromView = transitionContext
            .viewController(forKey: UITransitionContextViewControllerKey.from)?.view,
            let toView = transitionContext
                .viewController(forKey: UITransitionContextViewControllerKey.to)?.view else { return }
        if isPresenting {
            toView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            transitionContainerView.addSubview(toView)
            transitionContext.completeTransition(true)
            presentView(toView,
                        presentingView: fromView,
                        animationDuration: settings.animation.present.duration,
                        completion: nil)
        } else {
            dismissView(fromView,
                        presentingView: toView,
                        animationDuration: settings.animation.dismiss.duration) { completed in
                            if completed {
                                fromView.removeFromSuperview()
                            }
                            transitionContext.completeTransition(completed)
            }
        }
    }
    
    func presentView(_ presentedView: UIView,
                     presentingView: UIView,
                     animationDuration: Double,
                     completion: ((_ completed: Bool) -> Void)?) {
        onWillPresentView()
        let animationSettings = settings.animation.present
        containerView.updateConstraints()
        containerView.layoutIfNeeded()
        containerView.frame.origin = CGPoint(x: 0, y: containerView.frame.origin.y)
        UIView.animate(withDuration: animationDuration,
                       delay: animationSettings.delay,
                       usingSpringWithDamping: animationSettings.damping,
                       initialSpringVelocity: animationSettings.springVelocity,
                       options: animationSettings.options.union(.allowUserInteraction),
                       animations: { [weak self] in
                        if let transformScale = self?.settings.animation.scale {
                            presentingView.transform = CGAffineTransform(scaleX: transformScale.width, y: transformScale.height)
                        }
                        self?.performCustomPresentationAnimation(presentedView, presentingView: presentingView)
            },
                       completion: { finished in
                        completion?(finished)
        })
    }
    
    func dismissView(_ presentedView: UIView,
                     presentingView: UIView,
                     animationDuration: Double,
                     completion: ((_ completed: Bool) -> Void)?) {
        let animationSettings = settings.animation.dismiss
        
        UIView.animate(withDuration: animationDuration,
                       delay: animationSettings.delay,
                       usingSpringWithDamping: animationSettings.damping,
                       initialSpringVelocity: animationSettings.springVelocity,
                       options: animationSettings.options.union(.allowUserInteraction),
                       animations: { [weak self] in
                        if self?.settings.animation.scale != nil {
                            presentingView.transform = CGAffineTransform.identity
                        }
                        self?.performCustomDismissingAnimation(presentedView, presentingView: presentingView)
            },
                       completion: { _ in
                        completion?(true)
        })
    }
    
    func performCustomDismissingAnimation(_ presentedView: UIView, presentingView: UIView) {
        backgroundView.alpha = 0.0
        containerView.frame.origin.y = containerView.frame.origin.y
            + containerView.frame.height
            + settings.animation.dismiss.offset
            + safeAreaInsets.bottom
            + pulleyView.frame.size.height
            + 8
        pulleyView.frame.origin.y = containerView.frame.origin.y - 8
    }
    
    func onWillPresentView() {
        backgroundView.alpha = 0.0
        containerView.frame.origin.y = view.bounds.size.height + 8
        pulleyView.frame.origin.y = containerView.frame.origin.y - 8
    }
    
    func performCustomPresentationAnimation(_ presentedView: UIView, presentingView: UIView) {
        backgroundView.alpha = TNChartConfiguration.chartAppearance.sheet.backgroundAlpha
        containerView.frame = view.bounds
        pulleyView.frame.origin.y = containerView.frame.origin.y - 8
    }
    
}

extension SheetController: UIViewControllerAnimatedTransitioning { }
