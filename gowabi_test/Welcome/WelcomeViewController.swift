//
//  WelcomeViewController.swift
//  gowabi_test
//
//  Created by Francis Myat on 9/22/22.
//

import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var continueButton: UIButton!

    var welcomeViewModel = WelcomeViewModel()
    
    let disposeBag = DisposeBag()
    
    private var currencies = PublishSubject<Currency>()
    private var model: Currency!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        welcomeViewModel.requestCurrencyData()
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        // observing errors to show
        welcomeViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    print(message)
                case .serverMessage(let message):
                    print(message)
                }
            })
            .disposed(by: disposeBag)
        
        
        // binding data to picker
        welcomeViewModel
            .currencies
            .observe(on: MainScheduler.instance)
            .bind(to: currencyPicker.rx.itemTitles) { _, item in
                return "\(item.label ?? "")"
            }
            .disposed(by: disposeBag)
        
        welcomeViewModel
            .currencies
            .map({ $0.first! })
            .observe(on: MainScheduler.instance)
            .bind(to: currencies)
            .disposed(by: disposeBag) 
        
        currencyPicker
            .rx
            .modelSelected(Currency.self)
            .subscribe(onNext: { models in
                if let model = models.first {
                    self.model = model
                }
            })
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .subscribe(onNext: { _ in
                self.handleContinueAction(currency: self.model)
            })
            .disposed(by: disposeBag)
       
    }
    
    func handleContinueAction(currency: Currency) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = storyBoard.instantiateViewController(withIdentifier: ServicesViewController.className) as? ServicesViewController {
            vc.serviceViewModel.currency = currency
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
