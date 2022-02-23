//
//  BaseWireframe.swift
//  Currency
//
//  Created by Zyad Galal on 21/02/2022.
//

import UIKit
import RxCocoa
import RxSwift

class BaseWireframe<T: BaseViewModel, R: BaseRouter>: UIViewController {
    var viewModel: T!
    var router: R!
    let progressIndicator = ProgressIndicator()
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel)
        bindStates()
    }

    init(viewModel: T, router: R) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(progressIndicator)
    }

    override func viewWillDisappear(_ animated: Bool) {
        progressIndicator.removeFromSuperview()
    }
    func bind(viewModel: T) {
        fatalError("Please override bind function")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bindStates() {
        viewModel.displayError.subscribe { [weak self] (text) in
            self?.displayError(text: text)
        }.disposed(by: disposeBag)

        viewModel.isLoading.subscribe { [weak self] (isLoading) in
            guard let self = self else {return}
            guard let isLoading = isLoading.element else { return }
            if isLoading {
                self.progressIndicator.show(with: "Loading")
            } else {
                self.progressIndicator.hide()
            }
        }.disposed(by: disposeBag)

    }
}

extension BaseWireframe {
    func displayError(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}
