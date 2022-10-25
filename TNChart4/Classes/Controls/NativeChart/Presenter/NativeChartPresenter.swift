//
//  NativeChartNativeChartPresenter.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22/12/2020.
//  Copyright © 2020 Tradernet. All rights reserved.
//

import Foundation
import UIKit
import Charts

public enum ChartDataState {
    case loading
    case success
    case failure(NativeChartError)
    case empty
}

public enum NativeChartError: LocalizedError {
    case networkError(String)
    case emptyList
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let text):
            return text
        case .emptyList:
            return TNChartConfiguration.localized.emptyListError
        }
    }
}

// MARK: - Class

class NativeChartPresenter {

    // MARK: - Viper Variables
    
    weak var view: NativeChartViewInput?
    var interactor: NativeChartInteractorInput?
    
    // MARK: - Variables
    
    private var axisTransformer = TNAxisPositionTransformer()
    private var chartType: TNChartType = .candles
    private var chartController: TNChartControllerable!
    private var currentChartPeriod: TNChartPeriod = .day
    private var accessToNextPage: Bool = true
    private var tickerName: String?
    private var isDemo: Bool = true
    private var isEndOfPages: Bool = false
    private var isTestMode: Bool = false
    private var testIndex: Int = 0
    private var actualDataTimer: Timer?
    private var lastTime: TimeInterval?
    private var isUpdateData: Bool = false
    private var swap = SwapEntryData(attempts: 5, targetSize: 500)
    
    // MARK: - Functions
    
    private func updateLegend(_ entry: ChartDataEntry) {
        guard let chartData = entry.data as? TNChartData else { return }
        let date = Date(timeIntervalSince1970: chartData.time)
        let time = date.toString(format: .custom("dd.MM.yyyy HH:mm")) ?? ""
        
        let quote = chartData.info.defaultTicker
        let volume = chartData.volume
        let hight = chartData.high
        let low = chartData.low
        let open = chartData.open
        let close = chartData.close
        
        let resultString = NSMutableAttributedString(string: "\(time)   ")
        
        let bulletAttachment = NSTextAttachment()
        bulletAttachment.image = TNChartConfiguration.imageResources.bulletAttachmentImage
        bulletAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
        let bulletString = NSAttributedString(attachment: bulletAttachment)
        
        let dataString = NSAttributedString(string: "   \(quote) H: \(hight) L: \(low) O: \(open) C: \(close) V: \(volume)")
        
        resultString.append(bulletString)
        resultString.append(dataString)
        
        let attrRange = NSRange(location: 0, length: resultString.length)
        resultString.addAttributes(TNChartConfiguration.chartAppearance.module.legendAttributes,
                                   range: attrRange)
        
        view?.updateLegend(resultString)
    }
    
    private func setupCandleChart() {
        setupSwapDataEntries()
        resetTimer()
        isEndOfPages = false
        chartController = TNCombinedChartController(axisTransformer: axisTransformer,
                                                    axisValueFormatter: TNXAxisValueFormatter(axisTransformer: axisTransformer),
                                                    chartType: chartType)
        chartController.onSelectEntry = { [weak self] entry in
            self?.updateLegend(entry)
        }
    }
    
    private func setupTimerForActualData(lastEntryTime: TimeInterval,
                                         candleWidth: TimeInterval) {
        self.lastTime = lastEntryTime
        let currentTime = Date().timeIntervalSince1970
        var timeInterval = isTestMode
            ? 10.0
            : (lastEntryTime + candleWidth) - currentTime
        if timeInterval <= 0 {
            timeInterval =  60.0
        }
        resetTimer()
        actualDataTimer = Timer.scheduledTimer(timeInterval: timeInterval,
                                               target: self,
                                               selector: #selector(fetchUpdatedEntries),
                                               userInfo: nil,
                                               repeats: false)
    }
    
    private func resetTimer() {
        actualDataTimer?.invalidate()
        actualDataTimer = nil
    }
    
    private func nextPage() {
        guard !isEndOfPages else { return }
        guard accessToNextPage else { return }
        accessToNextPage = false
        view?.updateLoadingState(isLoading: true)
        view?.updateChartState(.loading)
        interactor?.nextPage()
    }
    
    @objc
    private func fetchUpdatedEntries() {
        isUpdateData = true
        isTestMode
            ? onFetchedChartData([createTNChartData()])
            : interactor?.fetchUpdatedEntries()
    }
    
    private func setupSwapDataEntries() {
        swap = SwapEntryData(attempts: 3, targetSize: 500)
        swap.onInsufficentData { [weak self] in
                guard let self = self else { return }
                self.isUpdateData = false
                self.accessToNextPage = true
                self.nextPage()
            }
            .onFilledUp { [weak self] entries  in
                self?.processing(chartData: entries)
                
            }
    }
    
    private func processing(chartData: [TNChartData]) {
        defer {
            isUpdateData = false
            accessToNextPage = true
        }
        view?.updateChartState(.success)
        guard !chartData.isEmpty else {
            if chartController.isEmpty {
                view?.updateChartState(.failure(.emptyList))
            }
            return
        }
        
        let isEmptyChart = chartController.isEmpty
        var lastTime: TimeInterval?
        var isUsefulData: Bool = false
        chartController.append(entries: chartData,
                               isUsefulData: &isUsefulData,
                               actualEntryTime: &lastTime)
        isEndOfPages = !isUsefulData && !isUpdateData
        
        if let lastTime = lastTime {
            setupTimerForActualData(lastEntryTime: lastTime,
                                    candleWidth: currentChartPeriod.candleWidth)
        }
        if isEmptyChart {
            view?.setupChartController(chartController)
            chartController.notifyDataChanged()
        } else {
            if isUsefulData {
                view?.fixScaleAndPosition()
            }
        }
        view?.updateLoadingState(isLoading: false)
    }
    
}

// MARK: - ModuleInput

extension NativeChartPresenter: NativeChartModuleInput {
    
    func configure(withTicker ticker: String?,
                   isDemo: Bool) {
        self.tickerName = ticker
        self.isDemo = isDemo
    }
    
    func forceReload() {
        view?.updateChartState(.empty)
        chartController.clear()
        chartController.notifyDataChanged()
        setupCandleChart()
        interactor?.configure(ticker: tickerName ?? "",
                              chartType: currentChartPeriod,
                              isDemo: isDemo)
        nextPage()
    }
    
}

// MARK: - ViewOutput

extension NativeChartPresenter: NativeChartViewOutput {

    func update() {
        guard !chartController.isEmpty, accessToNextPage else {
            return
        }
        isUpdateData = true
        interactor?.fetchUpdatedEntries()
    }
    
    func changeChartPeriodType(_ period: TNChartPeriod) {
        guard currentChartPeriod != period,
              let tickerName = tickerName else {
            currentChartPeriod = period
            return
        }
        currentChartPeriod = period
        axisTransformer = TNAxisPositionTransformer()
        setupCandleChart()
        interactor?.configure(ticker: tickerName,
                              chartType: period,
                              isDemo: isDemo)
        nextPage()
    }
    
    func setChartType(_ chartType: TNChartType) {
        guard chartController.chartType != chartType else { return }
        chartController.chartType = chartType
        self.chartType = chartType
    }
    
    func nextPageIfNeed(lowestVisibleX: Double,
                        visibleXRange: Double,
                        chartXMin: Double) {
        let delta = (lowestVisibleX - chartXMin)
        if delta < (visibleXRange * 3) {
            nextPage()
        }
    }
    
    func viewIsReady() {
        view?.setupInitialState()
        setupCandleChart()
        guard let tickerName = tickerName else { return }
        interactor?.configure(ticker: tickerName,
                              chartType: currentChartPeriod,
                              isDemo: true)
        nextPage()
    }
    
    func reload() {
        nextPage()
    }
    
    func resetAll() {
        resetTimer()
        axisTransformer = TNAxisPositionTransformer()
        currentChartPeriod = .day
        accessToNextPage = true
        tickerName = nil
        isDemo = true
        isEndOfPages = false
        view?.updateLegend(NSAttributedString(string: ""))
        view?.updateChartState(.empty)
        chartController.clear()
        chartController.notifyDataChanged()
        setupCandleChart()
    }
    
    func dispose() {
        resetAll()
    }
    
}

// MARK: - InteractorOutput

extension NativeChartPresenter: NativeChartInteractorOutput {
   
    func onFetchedChartData(_ chartData: [TNChartData]) {
        swap.append(chartData)
    }
    
    func onError(_ error: NativeChartError) {
        accessToNextPage = true
        guard chartController.isEmpty else { return }
        view?.updateChartState(.failure(error))
    }
    
}

// FUNCTIONS FOR TESTING

extension NativeChartPresenter {
    
    func createTNChartData() -> TNChartData {
        defer { testIndex += 1 }
        return TNChartData(time: (self.lastTime ?? 0) + Double((900)),
                           volume: 30.4,
                           hloc: [30.4, 30.4, 30.4, 30.4],
                           info: TNChartDataInfo(defaultTicker: "HZ"))
    }
    
}

private class SwapEntryData {
    private var attempts: Int
    private var swap: [TNChartData] = []
    private var isFinished: Bool = false
    private let targetSize: Int
    
    private var closureFilledUp: (([TNChartData]) -> Void)?
    private var closureInsufficientData: (() -> Void)?
    
    init(attempts: Int, targetSize: Int) {
        self.attempts = attempts
        self.targetSize = targetSize
    }
    
    func onInsufficentData(_ closure: @escaping (() -> Void)) -> Self {
        closureInsufficientData = closure
        return self
    }
    
    func onFilledUp(_ closure: @escaping (([TNChartData]) -> Void)) -> Self {
        closureFilledUp = closure
        return self
    }
    
    func append(_ chartData: [TNChartData]) -> Self {
        guard !isFinished else {
            closureFilledUp?(chartData)
            return self
        }
        swap.append(contentsOf: chartData)
        if (swap.count >= targetSize || attempts <= 0) {
            isFinished = true
            closureFilledUp?(swap)
        } else {
            attempts -= 1
            closureInsufficientData?()
        }
        return self
    }
    
}
