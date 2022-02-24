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
        setupTableViewBindings()
    }

    private func setupSegmentedControlEvents() {
        segmentedControl.rx.controlEvent(.valueChanged).subscribe { [weak self] _ in
            guard let self = self else {return}
            self.viewModel.segmentedControlChange(to: self.segmentedControl.selectedSegmentIndex)

        }.disposed(by: disposeBag)
    }

    private func setupTableViewBindings() {
        self.viewModel.otherCurrencies.bind(to: currencyTableView.rx.items(cellIdentifier: "otherCurrencies", cellType: OtherCurrenciesTableViewCell.self)) { _, item, cell in

            let convertedAmount = self.viewModel.convertCurrency(firstCurrencyRate: item.value, secondCurrencyRate: self.viewModel.currencyDetails.fromCurrencyRate, amount: 1)
            cell.config(fromCurrency: self.viewModel.currencyDetails.fromCurrency, convertedAmount: convertedAmount, toCurrency: item.key)

        }.disposed(by: disposeBag)

//        self.viewModel.lastDays.bind(to: currencyTableView.rx.items(cellIdentifier: "LastDaysTableViewCell", cellType: LastDaysTableViewCell.self)) {row , item, cell in
//            
//        }.disposed(by: disposeBag)
    }
    private func registerCells () {
        self.currencyTableView.register(UINib(nibName: "OtherCurrenciesTableViewCell", bundle: nil), forCellReuseIdentifier: "otherCurrencies")
        self.currencyTableView.register(UINib(nibName: "LastDaysTableViewCell", bundle: nil), forCellReuseIdentifier: "LastDaysTableViewCell")
    }
}
