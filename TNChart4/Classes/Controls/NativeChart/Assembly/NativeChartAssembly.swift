// swiftlint:disable:this file_name
//
//  NativeChartNativeChartAssembly.swift
//  terminal
//
//  Created by Dmitriy Safarov on 22/12/2020.
//  Copyright © 2020 Tradernet. All rights reserved.
//

import Swinject

class NativeChartAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        
        container.register(NativeChartPresenter.self) { (resolver,
                                                         viewController: NativeChartViewController,
                                                         interactor: NativeChartInteractorInput) in
            let presenter = NativeChartPresenter()
            presenter.view = viewController
            presenter.interactor = interactor
            var interactor = interactor
            interactor.output = presenter
            return presenter
        }
        
        container.register(NativeChartViewController.self) { (resolver,
                                                              interactor: NativeChartInteractorInput) in
            let viewController = NativeChartViewController()
            viewController.output = resolver.resolve(NativeChartPresenter.self, arguments: viewController, interactor)
            return viewController
        }
    }
    
}
