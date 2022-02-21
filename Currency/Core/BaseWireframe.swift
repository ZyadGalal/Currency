//
//  BaseWireframe.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import UIKit
import RxCocoa
import RxSwift

class BaseWireframe<T: BaseViewModel>: UIViewController {
    var viewModel: T!

    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel)
        bindStates()
    }
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func bind(viewModel: T){
        fatalError("Please override bind function")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bindStates(){
        viewModel.displayError.subscribe { [weak self] (text) in
            self?.displayError(text: text)
        }.disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe { [weak self] (isLoading) in
            guard let isLoading = isLoading.element else { return }
            if(isLoading){
                //self?.view.makeToastActivity(.center)
            } else {
                //self?.view.hideToastActivity()
            }
        }.disposed(by: disposeBag)

    }
}

extension BaseWireframe {
    func displayError(text: String){
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}
