//
//  WelcomeViewModel.swift
//  gowabi_test
//
//  Created by Francis Myat on 9/22/22.
//

import Foundation
import RxSwift
import RxCocoa

public enum NetworkError {
    case internetError(String)
    case serverMessage(String)
}

class WelcomeViewModel {
    
    public enum WelcomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let currencies : PublishSubject<[Currency]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<NetworkError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    public func requestCurrencyData() {
        self.loading.onNext(true)
        APIManager.requestData(url: "632c05c6e13e6063dcb0e196?meta=false", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                let currencies = returnJson["currencies"].arrayValue.compactMap {return Currency(data: try! $0.rawData())}
                self.currencies.onNext(currencies)
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
    }
}
