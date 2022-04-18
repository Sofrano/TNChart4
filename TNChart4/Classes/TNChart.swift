//
//  NativeChatFacade.swift
//  terminal
//
//  Created by Dmitriy Safarov on 17.05.2021.
//

import Foundation
import RxCocoa
import RxSwift
import Swinject
import SnapKit
import UIKit

public protocol TNChartDelegate: AnyObject {
    func didChangeChartState(_ state: ChartDataState)
}

public class TNChart {
    
    // MARK: - Variables
    
    public weak var delegate: TNChartDelegate?

    public let isDemoUser: Bool
    public let viewController: UIViewController
    private var chartViewController: NativeChartViewController {
        // swiftlint:disable:next force_cast
        return viewController as! NativeChartViewController
    }
    private let disposeBag = DisposeBag()
    
    public private(set) var ticker: String?
    
    public var activityIndicatorView: UIActivityIndicatorView { chartViewController.chartActivityIndicatorView }
    
    public var legendView: UIView { chartViewController.legendLabel }
    
    public var period: TNChartPeriod {
        chartViewController.chartPeriod
    }
    
    public var type: TNChartType {
        chartViewController.chartType
    }
    
    public var hasData: Bool {
        chartViewController.hasData
    }
    
    // MARK: - Constructors
    
    public init(interactor: NativeChartInteractorInput, isDemoUser: Bool = true) {
        let container = Container()
        NativeChartAssemblyContainer().assemble(container: container)
        guard let vc = container.resolve(NativeChartViewController.self, argument: interactor) else {
            fatalError("NativeChartViewController not resolved")
        }
        self.isDemoUser = isDemoUser
        self.viewController = vc
        subscribeToChartState()
    }
    
    // MARK: - Public Functions
    
    public func update() {
        chartViewController.update()
    }
    
    /// Reload if needed
    public func reloadIfNeeded() {
        chartViewController.reloadIfNeed()
    }
    
    /// Reload chart
    ///
    /// Overloads data for the last not loaded page
    public func reload() {
        chartViewController.reload()
    }
    
    /// Clear all chart data
    public func clear() {
        chartViewController.reset()
    }

    public func set(period: TNChartPeriod) {
        chartViewController.onChangePeriod(period)
    }
    
    public func set(type: TNChartType) {
        chartViewController.onChangeType(type)
    }
    
    public func set(ticker: String) {
        (chartViewController.output as? NativeChartModuleInput)?.configure(withTicker: ticker,
                                                                           isDemo: isDemoUser)
        self.ticker = ticker
    }
    
    public func set(ticker: String? = nil,
                    period: TNChartPeriod? = nil,
                    type: TNChartType? = nil) {
        if let ticker = ticker { set(ticker: ticker) }
        if let period = period { set(period: period) }
        if let type = type { set(type: type) }
    }
    
    // MARK: - Private Functions
    
    private func subscribeToChartState() {
        chartViewController.chartState.asDriver(onErrorJustReturn: .loading)
            .drive(onNext: { [weak self] (chartState) in
                self?.delegate?.didChangeChartState(chartState)
            })
            .disposed(by: disposeBag)
    }
    
}
