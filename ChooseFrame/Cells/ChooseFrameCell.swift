//
//  ChooseFrameCell.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit
import ReactorKit

final class ChooseFrameCell: BaseCollectionViewCell, View {
    typealias Reactor = ChooseFrameCellReactor
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(reactor: Reactor) { }
    
    var model: ChooseFrameModel?
    
    func configureCell(for item: ChooseFrameModel) {
        self.model = item

        frameImageView.image = model?.image
        if model!.isChoose {
            chooseImageView.isHidden = false
        } else {
            chooseImageView.isHidden = true
        }
    }

    // MARK: - Initialize
    override func initialize() {
        self.configureUI()
    }
    
    // MARK: - UIComponents
    var frameImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    var chooseImageView: UIImageView = {
        $0.image = UIImage(systemName: "checkmark.circle.fill")
        $0.isHidden = true
        return $0
    }(UIImageView())

}

extension ChooseFrameCell {
    private func configureUI() {
        contentView.addSubview(frameImageView)
        frameImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        frameImageView.addSubview(chooseImageView)
        chooseImageView.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(10)
            $0.width.height.equalTo(32)
        }
    }
}


final class ChooseFrameCellReactor: Reactor {
    typealias Action = NoAction
    
    var initialState: ChooseFrameModel
    
    init(initialState: ChooseFrameModel) {
        self.initialState = initialState
    }
}
