//
//  SubtitleView.swift
//  Learn CS in AR
//
//  Created by Jayven Nhan on 5/16/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit
import SnapKit

protocol SubtitleViewDelegate: class {
    func closeButtonDidTouchUpInside()
    func sliderButtonDidTouchUpInside()
    func maximizeSubtitleView()
    func minimizeSubtitleView()
    func subtitleDidTranslate(y: CGFloat)
}

final class SubtitleView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        return label
    }()
    
    var lesson: Lesson
    
    weak var delegate: SubtitleViewDelegate?
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrow down").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(SubtitleView.closeButtonDidTouchUpInside(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var textView = SubtitleTextView(lesson: lesson)
    
    let titleLabelSpacerView: UIView = {
        return UIView()
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, titleLabelSpacerView])
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        return stackView
    }()
    
    let verticalSpacerView: UIView = UIView()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, textView])
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var sliderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.82, green:0.82, blue:0.85, alpha:1.00)
        return button
    }()
    
    lazy var expanderView: UIView = {
        let view = UIView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderButtonDidTouchUpInside(_:)))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .clear
        return view
    }()
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.roundCorners([.topLeft, .topRight], radius: 30.0)
        return view
    }()
    
    init(lesson: Lesson) {
        self.lesson = lesson
        super.init(frame: .zero)
        setUpLayout()
        setInitialProperties()
        textView.alwaysBounceVertical = true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topLeft, .topRight], radius: 30.0)
    }
    
    func setInitialProperties() {
        alpha = 0
    }
    
    // MARK: SubtitleView - Action methods
    @objc func closeButtonDidTouchUpInside(_ sender: UIButton) {
        delegate?.closeButtonDidTouchUpInside()
    }
    
    @objc func sliderButtonDidTouchUpInside(_ sender: UIButton) {
        delegate?.sliderButtonDidTouchUpInside()
    }
    
    @objc func maximizeSubtitleView(_ sender: UIButton) {
        delegate?.maximizeSubtitleView()
    }
    
    @objc func minimizeSubtitleView(_ sender: UIButton) {
        delegate?.minimizeSubtitleView()
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            break
        case .changed:
            let translation = gestureRecognizer.translation(in: self.superview)
            print("Translation:", translation.y)
            let velocity = gestureRecognizer.velocity(in: self.superview)
            print("Velocity:", velocity.y)
            var transform = CGAffineTransform.identity
            transform = transform.translatedBy(x: 0, y: translation.y)
            self.delegate?.subtitleDidTranslate(y: translation.y)
            self.transform = transform
        case .ended:
            let translation = gestureRecognizer.translation(in: self.superview)
            let velocity = gestureRecognizer.velocity(in: self.superview)
            print("Velocity:", velocity.y)
            print("Translation:", translation.y)
            UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = .identity
                if translation.y < -150 || velocity.y < -500 {
                    self.delegate?.maximizeSubtitleView()
                } else if translation.y > 100 || velocity.y > 500 {
                    self.delegate?.minimizeSubtitleView()
                } else {
//                    self.delegate?.minimizeSubtitleView()
                }
                self.setNeedsDisplay()
            }, completion: nil)
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: SubtitleView - Layout
extension SubtitleView {
    func setUpLayout() {
        
        addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview()
        }
//        mainView.layer.cornerRadius = 30
        
        mainView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(snp.leading).offset(24)
            $0.top.equalToSuperview().offset(32)
            $0.trailing.equalTo(snp.trailing).offset(-24)
            $0.bottom.equalTo(snp.bottom)
        }
        
//        topStackView.snp.makeConstraints {
//            $0.height.equalTo(48)
//        }
        
        mainView.addSubview(sliderButton)
//        sliderButton.isHidden = true
        let height: CGFloat = 8
        sliderButton.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(height)
            $0.top.equalToSuperview().offset(height)
            $0.centerX.equalToSuperview()
        }
        sliderButton.layer.cornerRadius = height / 2
        
        mainView.addSubview(expanderView)
        expanderView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        mainView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.trailing.equalTo(stackView)
            $0.height.width.equalTo(44)
            $0.centerY.equalTo(titleLabel)
        }
        
        titleLabelSpacerView.snp.makeConstraints {
            $0.width.equalTo(closeButton)
        }
        
//        let separatorView = UIView()
//        separatorView.backgroundColor = sliderButton.backgroundColor
//        mainView.addSubview(separatorView)
//        separatorView.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(expanderView)
//            $0.height.equalTo(0.5)
//        }
    }
}

// MARK: SubtitleView - Ordering
extension SubtitleView {
    func setOrdering() {
        setOrderingTitleLabel()
        textView.setOrderingText()
    }
    
    func setOrderingTitleLabel() {
        let titleColor = UIColor.black
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: titleColor,
                                   NSAttributedStringKey.font: Font(object: .textViewTitle).instance]
        let titleAttributedText = NSMutableAttributedString(string: "Ordering", attributes: titleTextAttributes)
        titleLabel.attributedText = titleAttributedText
    }
}

// MARK: SubtitleView - Operation
extension SubtitleView {
    func setOperation() {
        setOperationTitleLabel()
        textView.setOperationText()
    }
    
    func setOperationTitleLabel() {
        let titleColor = UIColor.black
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: titleColor,
                                   NSAttributedStringKey.font: Font(object: .textViewTitle).instance]
        let titleAttributedText = NSMutableAttributedString(string: "Operation", attributes: titleTextAttributes)
        titleLabel.attributedText = titleAttributedText
        titleLabel.lineBreakMode = .byTruncatingTail
    }
}

// MARK: SubtitleView - Big O
extension SubtitleView {
    func setBigO() {
        setBigOTitleLabel()
        textView.setBigOText()
    }
    
    func setBigOTitleLabel() {
        let titleColor = UIColor.black
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: titleColor,
                                   NSAttributedStringKey.font: Font(object: .textViewTitle).instance]
        let titleAttributedText = NSMutableAttributedString(string: "Big O", attributes: titleTextAttributes)
        titleLabel.attributedText = titleAttributedText
    }
}
