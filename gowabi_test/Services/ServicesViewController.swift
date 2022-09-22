//
//  ServicesViewController.swift
//  gowabi_test
//
//  Created by Francis Myat on 9/22/22.
//

import UIKit
import RxSwift
import RxCocoa

class ServicesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
     
    private var services = PublishSubject<[Service]>()
    private let disposeBag = DisposeBag()
    
    var serviceViewModel = ServiceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        serviceViewModel.requestServiceData()
    }
    
    private func setupBinding() {
        
        tableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: String(describing: ServiceCell.self))
                
        // observing errors to show
        serviceViewModel
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
        
        // binding data to tableview
        serviceViewModel
            .services
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "ServiceCell", cellType: ServiceCell.self))
            {  (row, service, cell) in
                cell.currency = self.serviceViewModel.currency
                cell.cellService = service
            }
            .disposed(by: disposeBag)
        
    }

}
