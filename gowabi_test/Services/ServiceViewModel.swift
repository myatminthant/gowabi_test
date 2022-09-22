//
//  ServiceViewModel.swift
//  gowabi_test
//
//  Created by Francis Myat on 9/23/22.
//

import Foundation
import RxSwift
import RxCocoa

class ServiceViewModel {
    
    public let services : PublishSubject<[Service]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<NetworkError> = PublishSubject()
    
    public var currency: Currency!
    
    private let disposable = DisposeBag()
    
    
    public func requestServiceData() {
        self.loading.onNext(true)
        APIManager.requestData(url: "632c08e6e13e6063dcb0e4cb?meta=false", method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                let services = returnJson["services"].arrayValue.compactMap {return Service(data: try! $0.rawData())}.filter({ $0.currency_id == self.currency.id})
                self.services.onNext(services)
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
