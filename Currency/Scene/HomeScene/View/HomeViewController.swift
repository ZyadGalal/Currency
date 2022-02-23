//
//  HomeViewController.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: BaseWireframe<HomeViewModel, HomeRouter> {

    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var convertedValueTextField: UITextField!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    
    lazy var fromPickerView: UIPickerView = {
        return UIPickerView()
    }()
    let toPickerView: UIPickerView = {
        return UIPickerView()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        viewModel.viewDidLoad()
    }

    func setupUI() {
        fromTextField.inputView = fromPickerView
        createDoneBtn(for: fromTextField)
        
        toTextField.inputView = toPickerView
        createDoneBtn(for: toTextField)
    }
    func createDoneBtn (for textField : UITextField)
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(donePressedOfPickerView))
        toolbar.setItems([done], animated: true)
        textField.inputAccessoryView = toolbar
    }
    @objc func donePressedOfPickerView()
    {
        self.view.endEditing(true)
    }
    override func bind(viewModel: HomeViewModel) {
        amountTextField.rx.controlEvent([.editingChanged])
            .subscribe({ [weak self] _ in
                guard let self = self else {return}
                self.viewModel.amountValueDidChanged(to: self.amountTextField.text!)
            }).disposed(by: disposeBag)
        
        convertedValueTextField.rx.controlEvent([.editingChanged])
            .subscribe({ [weak self] _ in
                guard let self = self else {return}
                self.viewModel.convertedValueDidChanged(to: self.convertedValueTextField.text!)
            }).disposed(by: disposeBag)
        
        detailsButton.rx.tap.subscribe{ [weak self] event in
            guard let self = self else {return}
            let detailsViewController = self.router.createDetailsController(fromCurrency: viewModel.fromCurrency, toCurrency: viewModel.toCurrency, otherCurrencies: viewModel.getTenOtherCurrencies())
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }.disposed(by: disposeBag)
        
        swapButton.rx.tap.subscribe{[weak self] event in
            guard let self = self else {return}
            self.viewModel.swapButtonDidClicked()
        }.disposed(by: disposeBag)
        
        viewModel.pickerItems.bind(to: fromPickerView.rx.itemTitles){_, item in
            return "\(item)"
            
        }.disposed(by: disposeBag)
        
        fromPickerView.rx.itemSelected.subscribe{[weak self] event in
            guard let self = self else {return}
            switch event {
            case .next(let selected):
                self.viewModel.fromPickerViewDidSelect(row: selected.row)
            default:
                break
            }
        }.disposed(by: disposeBag)
        
        toPickerView.rx.itemSelected.subscribe{[weak self] event in
            guard let self = self else {return}
            switch event {
            case .next(let selected):
                self.viewModel.toPickerViewDidSelect(row: selected.row)
            default:
                break
            }
        }.disposed(by: disposeBag)
        
        viewModel.pickerItems.bind(to: toPickerView.rx.itemTitles){_, item in
            return "\(item)"
            
        }.disposed(by: disposeBag)
        
        viewModel.fromField.bind(to: fromTextField.rx.text.orEmpty).disposed(by: disposeBag)
        viewModel.toField.bind(to: toTextField.rx.text.orEmpty).disposed(by: disposeBag)
        viewModel.amountField.bind(to: amountTextField.rx.text.orEmpty).disposed(by: disposeBag)
        viewModel.convertedField.bind(to: convertedValueTextField.rx.text.orEmpty).disposed(by: disposeBag)

    }
}

