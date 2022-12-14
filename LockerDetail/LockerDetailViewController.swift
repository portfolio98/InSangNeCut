//
//  LockerDetailViewController.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/02.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

final class LockerDetailViewController: UIViewController, View {
    typealias Reactor = LockerDetailReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        dispatch(reactor: reactor)
        render(reactor: reactor)
    }
    
    private func dispatch(reactor: Reactor) {
        disposeBag.insert {
            self.rx.viewDidLoad
                .map { _ in Reactor.Action.viewDidLoad }
                .bind(to: reactor.action)
            
            scrollView.rx.gesture(.swipe(direction: .right))
                .skip(1)
                .map { _ in Reactor.Action.didTapBack }
                .bind(to: reactor.action)
            
            chevronBackwardBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapBack }
                .bind(to: reactor.action)
            
            pencilCircleBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapPencil }
                .bind(to: reactor.action)
            
            confirmBarButtonItem.rx.tap
                .withUnretained(self)
                .map { this, _ in Reactor.Action.didTapConfirm(this.textView.text) }
                .bind(to: reactor.action)
            
            trashCircleBarButtonItem.rx.tap
                .map { _ in Reactor.Action.didTapTrash }
                .bind(to: reactor.action)
            
            textView.rx.text
                .map { text -> Bool in return text != "" }
                .withUnretained(self)
                .bind { this, value in this.textView.placeholderLabel.isHidden = value }
        }
    }
    
    private func render(reactor: Reactor) {
        disposeBag.insert {
            reactor.pulse(\.$lockerModel)
                .withUnretained(self)
                .bind { this, model in
                    let id = model?.id ?? ""
                    this.imageView.image = ImageFileManager.shared.getSavedImage(id: id)
                    
                    this.textView.text = model?.text
                    this.descriptionLabel.text = model?.text
                }
            
            reactor.state.map { $0.isDismiss }
                .filter { $0 == true }
                .withUnretained(self)
                .bind { this, value in
                    this.navigationController?.popViewController(animated: true)
                }
            
            let isEditingStraem = reactor.state.map { $0.isEditing }.share()
            
            isEditingStraem.filter { $0 == true }
                .withUnretained(self)
                .bind { this, _ in
                    this.navigationItem.leftBarButtonItem = .init()
                    this.navigationItem.rightBarButtonItems = [this.confirmBarButtonItem]
                    
                    this.textView.becomeFirstResponder()
                    this.textView.isHidden = false
                    this.descriptionLabel.isHidden = true
                }
            
            isEditingStraem.filter { $0 == false }
                .withUnretained(self)
                .bind { this, value in
                    this.navigationItem.leftBarButtonItem = this.chevronBackwardBarButtonItem
                    this.navigationItem.rightBarButtonItems = [this.pencilCircleBarButtonItem, this.trashCircleBarButtonItem]
                    
                    this.textView.resignFirstResponder()
                    this.textView.isHidden = true
                    this.descriptionLabel.isHidden = false
                }
            
        }
    }

    // MARK: - Initialize
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIComponents
    lazy var chevronBackwardBarButtonItem = ChevronBackwardBarButtonItem(tintColor: .designSystem(.mainYellow))
    lazy var pencilCircleBarButtonItem = PencilCircleBarButtonItem(tintColor: .designSystem(.mainYellow))
    lazy var confirmBarButtonItem = TitleBarButtonItem(title: "완료")
    lazy var trashCircleBarButtonItem = TrashCircleBarButtonItem(tintColor: .designSystem(.mainYellow))

    var scrollView = UIScrollView()
    lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    lazy var descriptionLabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = .pretendardFont(size: 14, style: .light)
        $0.textColor = .black
        return $0
    }(UILabel())

    lazy var textView: PlaceHolderTextView = {
        $0.isHidden = true
        $0.font = .pretendardFont(size: 14, style: .light)
        return $0
    }(PlaceHolderTextView())
}

extension LockerDetailViewController {
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(view.frame.width)
        }
        
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
}

