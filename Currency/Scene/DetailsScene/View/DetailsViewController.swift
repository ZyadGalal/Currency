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
        registerCells()
        self.viewModel.viewLoaded()
    }

    override func bind(viewModel: DetailsViewModel) {
        setupSegmentedControlEvents()
        setupTableViewLastDaysBinding()
    }

    private func setupSegmentedControlEvents() {
        segmentedControl.rx.controlEvent(.valueChanged).subscribe { [weak self] _ in
            guard let self = self else {return}
            self.currencyTableView.dataSource = nil
            if self.segmentedControl.selectedSegmentIndex == 0 {
                self.setupTableViewLastDaysBinding()
            } else {
                self.setupTableViewOtherCurrenciesBinding()
            }
            self.viewModel.segmentedControlChange(to: self.segmentedControl.selectedSegmentIndex)

        }.disposed(by: disposeBag)
    }

    private func setupTableViewOtherCurrenciesBinding() {
        self.viewModel.otherCurrencies.bind(to: currencyTableView.rx.items(cellIdentifier: "otherCurrencies", cellType: OtherCurrenciesTableViewCell.self)) { _, item, cell in

            let convertedAmount = Double(1).convertCurrency(firstRate: item.value, secondRate: self.viewModel.currencyDetails.fromCurrencyRate)
            cell.config(fromCurrency: self.viewModel.currencyDetails.fromCurrency, convertedAmount: convertedAmount, toCurrency: item.key)
        }.disposed(by: disposeBag)

    }
    
    private func setupTableViewLastDaysBinding() {
        self.viewModel.lastDaysCurrency.bind(to: currencyTableView.rx.items(cellIdentifier: "LastDaysTableViewCell", cellType: LastDaysTableViewCell.self)) { row , item , cell in
            let currencyDetails = self.viewModel.currencyDetails
            let convertedAmount = Double(1).convertCurrency(firstRate: (item.rates![currencyDetails.toCurrency])!, secondRate: (item.rates![currencyDetails.fromCurrency])!)
            cell.config(date: item.date!, fromCurrency: currencyDetails.fromCurrency, toCurrency: currencyDetails.toCurrency, convertedRate: "\(convertedAmount)")
        }.disposed(by: disposeBag)
    }
    
    private func registerCells () {
        self.currencyTableView.register(UINib(nibName: "OtherCurrenciesTableViewCell", bundle: nil), forCellReuseIdentifier: "otherCurrencies")
        self.currencyTableView.register(UINib(nibName: "LastDaysTableViewCell", bundle: nil), forCellReuseIdentifier: "LastDaysTableViewCell")
    }
}

