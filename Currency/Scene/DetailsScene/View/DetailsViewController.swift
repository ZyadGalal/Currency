//
//  DetailsViewController.swift
//  Currency
//
//  Created by Zyad Galal on 22/02/2022.
//

import UIKit
import RxCocoa
import RxSwift

class DetailsViewController: BaseWireframe<DetailsViewModel, DetailsRouter> {

    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
    }
    
    override func bind(viewModel: DetailsViewModel) {
        segmentedControl.rx.controlEvent(.valueChanged).subscribe{ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.segmentedControlChange(to: self.segmentedControl.selectedSegmentIndex)
            
        }.disposed(by: disposeBag)
        

        self.currencyTableView.register(UINib(nibName: "otherCurrenciesTableViewCell", bundle: nil), forCellReuseIdentifier: "otherCurrencies")
        self.currencyTableView.register(UINib(nibName: "LastDaysTableViewCell", bundle: nil), forCellReuseIdentifier: "LastDaysTableViewCell")
        
        self.viewModel.otherCurrencies.bind(to: currencyTableView.rx.items(cellIdentifier: "otherCurrencies",cellType: otherCurrenciesTableViewCell.self)){ row , item , cell in
            
            let convertedAmount = self.viewModel.convertCurrency(firstCurrencyRate: item.value, secondCurrencyRate: self.viewModel.fromCurrencyRate, amount: 1)
            cell.currencyLabel.text = "1 \(self.viewModel.fromCurrency) = \(convertedAmount) \(item.key)"
            
        }.disposed(by: disposeBag)
        
        
    }
}

