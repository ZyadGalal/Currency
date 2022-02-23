//
//  ProgressIndicator.swift
//
//
//  Created by macOS on 8/8/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class ProgressIndicator: UIVisualEffectView {

    var text: String? {
        didSet {
            label.text = text
        }
    }
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .dark)
    let vibrancyView: UIVisualEffectView

    init() {
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
        self.isHidden = true
        self.alpha = 0
    }

    required init(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)!
        self.setup()
    }

    func setup() {
        contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(activityIndictor)
        vibrancyView.contentView.addSubview(label)
        self.activityIndictor.color = .gray

    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = self.superview {
            let width: CGFloat = 120 // superview.frame.size.width / 2.3
            let height: CGFloat = width
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds

            let activityIndicatorSize: CGFloat = width / 2
            activityIndictor.frame = CGRect(x: width / 2 - activityIndicatorSize / 2,
                                            y: height / 2 - 1.6 * (activityIndicatorSize / 2) ,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)

            layer.cornerRadius = 10
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: 0,
                                 y: width / 2,
                                 width: width,
                                 height: width * 0.5)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }

    func show(with text: String) {
        self.text = text
        activityIndictor.startAnimating()
        self.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { _ in
            self.isHidden = true
        }

        activityIndictor.stopAnimating()
    }
}
