//
//  HomeViewController.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: BaseWireframe<HomeViewModel> {

    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromCurrency: UITextField!
    @IBOutlet weak var toCurrency: UITextField!
    
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
        fromTextField.rx.controlEvent([.editingChanged])
            .subscribe({ [weak self] _ in
                guard let self = self else {return}
                self.viewModel.fromTextFieldDataChanged(with: self.fromTextField.text!)
            }).disposed(by: disposeBag)
        
        toTextField.rx.controlEvent([.editingChanged])
            .subscribe({ [weak self] _ in
                guard let self = self else {return}
                self.viewModel.toTextFieldDataChanged(with: self.toTextField.text!)

            }).disposed(by: disposeBag)
        
        viewModel.price.bind(to: fromCurrency.rx.text).disposed(by: disposeBag)
        
        viewModel.pickerItems.bind(to: fromPickerView.rx.itemTitles){_, item in
            return "\(item)"
            
        }.disposed(by: disposeBag)
        
        fromPickerView.rx.itemSelected.subscribe{ event in
            switch event {
            case .next(let selected):
                print(selected.row)
            default:
                break

            }
        }.disposed(by: disposeBag)
        
        toPickerView.rx.itemSelected.subscribe{ event in
            switch event {
            case .next(let selected):
                print(selected.row)
            default:
                break
            }
        }.disposed(by: disposeBag)
        
        viewModel.pickerItems.bind(to: toPickerView.rx.itemTitles){_, item in
            return "\(item)"
            
        }.disposed(by: disposeBag)
    }
}

