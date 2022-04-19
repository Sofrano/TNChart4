//
//  NativeChartNativeChartViewController.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22/12/2020.
//  Copyright © 2020 Tradernet. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit
import Charts

class NativeChartViewController: UIViewController {
    
    // MARK: - UI Variables
    
    public lazy var legendLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byClipping
        self.view.addSubview(label)
        return label
    }()
    
    public lazy var chartActivityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: appearance.activityIndicatorStyle)
        view.addSubview(indicator)
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var chartView: CombinedChartView = {
        let view = CombinedChartView()
        self.view.addSubview(view)
        view.keepPositionOnRotation = true
        view.delegate = self
        return view
    }()
    
    // MARK: - Variables
    private let appearance: TNChartModuleAppearancable = TNChartConfiguration.chartAppearance.module
    
    public var chartType: TNChartType = .candles
    private var visibleXRange: Double = 0.0
    private var lowestVisibleX: Double = 0.0
    
    public var chartPeriod: TNChartPeriod = .day
    public var legendBottomConstraint: ConstraintItem { legendLabel.snp.bottom }
    
    public var hasData: Bool { chartView.barData?.entryCount ?? 0 > 0 }
    public var chartState = BehaviorSubject<ChartDataState>(value: .empty)
    public var output: NativeChartViewOutput?
    private var isAppearedBefore: Bool = false
    
    // MARK: - Life cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        themeView()
        setupChartView()
        output?.viewIsReady()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isAppearedBefore {
            output?.update()
        } else {
            configurePosition()
        }
        isAppearedBefore = true
    }
    
    deinit {
        output?.dispose()
    }
    
    // MARK: - Public Functions
    
    public func update() {
        output?.update()
    }
    
    public func reloadIfNeed() {
        guard let state = try? chartState.value() else { return }
        switch state {
        case .failure:
            output?.reload()
        default:
            break
        }
    }
    
    public func reload() {
        output?.reload()
    }
    
    public func reset() {
        output?.resetAll()
    }
    
    public func onChangeType(_ type: TNChartType) {
        chartType = type
        output?.setChartType(type)
    }
    
    public func onChangePeriod(_ period: TNChartPeriod) {
        chartPeriod = period
        output?.changeChartPeriodType(period)
    }
    
    // MARK: - Private functions
    
    private func setupConstraints() {
        chartView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(-8)
            
        }
        legendLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(16)
        }
        chartActivityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
    }
    
    private func themeView() {
        chartActivityIndicatorView.color = appearance.activityIndicatorColor
        chartActivityIndicatorView.style = appearance.activityIndicatorStyle
    }
    
    private func onChangeChartViewOutput() {
        updateHighlight()
        lowestVisibleX = floor(chartView.lowestVisibleX)
        visibleXRange = chartView.visibleXRange
        output?.nextPageIfNeed(lowestVisibleX: lowestVisibleX,
                               visibleXRange: chartView.visibleXRange,
                               chartXMin: chartView.chartXMin)
    }
    
    private func updateHighlight() {
        guard let lastHighlighted = chartView.lastHighlighted else {
            return
        }
        if chartView.data?.entry(for: lastHighlighted) != nil {
            chartView.highlighted = [lastHighlighted]
        }
        
        var newHighlight: Highlight?
        if let lastTouchPoint = chartView.lastTouchPoint {
            let offset = chartView.bounds.height / 20.0
            for index in 0..<20 {
                let targetPoint = CGPoint(x: lastTouchPoint.x, y: offset + offset * CGFloat(index))
                if let targetHighlight = chartView.getHighlightByTouchPoint(targetPoint) {
                    newHighlight = targetHighlight
                    break
                }
            }
        }
        if let newHighlight = newHighlight {
            if !newHighlight.isEqual(chartView.lastHighlighted) {
                chartView.highlightValue(newHighlight, callDelegate: true)
                chartView.lastHighlighted = newHighlight
            }
        } else {
            chartView.highlighted.removeAll(keepingCapacity: false)
            chartView.highlightValue(nil, callDelegate: true)
        }
    }
    
    private func setupChartView() {
        chartView.xAxis.gridColor = appearance.chartViewGridColor
        chartView.xAxis.gridLineDashLengths = [3]
        chartView.xAxis.forceLabelsEnabled = true
        chartView.xAxis.labelCount = 4
        chartView.xAxis.labelPosition = .bottom
        chartView.noDataText = ""
        chartView.xAxisRenderer = TNXAxisRenderer(viewPortHandler: chartView.xAxisRenderer.viewPortHandler,
                                                  axis: chartView.xAxis,
                                                  transformer: chartView.xAxisRenderer.transformer)
        chartView.xAxis.labelFont = appearance.xAxisTextFont
        chartView.xAxis.labelTextColor = appearance.xAxisTextColor
        chartView.xAxis.axisLineWidth = 0.0
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.gridLineDashLengths = [3]
        chartView.rightAxis.labelFont = appearance.yAxisTextFont
        chartView.rightAxis.gridColor = appearance.chartViewGridColor
        chartView.rightAxis.labelPosition = .insideChart
        chartView.rightAxis.labelTextColor = appearance.yAxisTextColor
        chartView.rightAxis.axisLineColor = appearance.yAxisLineColor
        
        chartView.backgroundColor = appearance.chartViewBackgroundColor
        chartView.dragDecelerationEnabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 12
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = false
        chartView.setDragOffsetX(250)
        chartView.autoScaleMinMaxEnabled = true
        chartView.doubleTapToZoomEnabled = false
        view.backgroundColor = appearance.chartViewBackgroundColor
        
    }
    
}

extension NativeChartViewController: ChartViewDelegate {
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        onChangeChartViewOutput()
    }
    
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        onChangeChartViewOutput()
    }

}

extension NativeChartViewController: NativeChartViewInput {

    func setupInitialState() {}

    func updateLoadingState(isLoading: Bool) {
        if isLoading {
            view.bringSubviewToFront(chartActivityIndicatorView)
            if !chartActivityIndicatorView.isAnimating {
                chartActivityIndicatorView.startAnimating()
            }
        } else {
            if chartActivityIndicatorView.isAnimating {
                chartActivityIndicatorView.stopAnimating()
            }
        }
        if chartActivityIndicatorView.isHidden != !isLoading {
            chartActivityIndicatorView.isHidden = !isLoading
        }
    }
    
    func updateLegend(_ value: NSAttributedString) {
        legendLabel.attributedText = value
    }
    
    func fixScaleAndPosition() {
        chartView.setVisibleXRangeMaximum(visibleXRange)
        chartView.setVisibleXRangeMinimum(visibleXRange)
        chartView.moveViewToX(lowestVisibleX)
        chartView.setVisibleXRangeMaximum(Double.greatestFiniteMagnitude)
        chartView.setVisibleXRangeMinimum(0.0)
    }
    
    func showError(text: String) {
        chartView.noDataText = text
    }
    
    func setupChartController(_ controller: TNChartControllerable) {
        controller.setupChartView(chartView)
        configurePosition()
    }
    
    func configurePosition() {
        chartView.stopDeceleration()
        var range = chartPeriod.range
        if let entryCount = chartView.data?.entryCount {
            range = range > Double(entryCount)
                ? Double(entryCount)
                : range
        }
        chartView.setVisibleXRangeMaximum(range)
        chartView.setVisibleXRangeMinimum(range)
        chartView.moveViewToX(chartView.chartXMax - range + (range / 100 * 30))
        chartView.setVisibleXRangeMaximum(Double.greatestFiniteMagnitude)
        chartView.setVisibleXRangeMinimum(0.0)
        lowestVisibleX = chartView.chartXMax + range
        visibleXRange = chartView.visibleXRange
    }
    
    func updateChartState(_ state: ChartDataState) {
        chartState.onNext(state)
    }
    
}
