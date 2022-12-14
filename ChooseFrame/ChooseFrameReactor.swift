//
//  ChooseFrameReactor.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit
import ReactorKit

final class ChooseFrameReactor: Reactor {
    typealias NeCutMakeType = NeCutMakeManager.NeCutMakeType
    enum Item: Hashable {
        case basicFrame1x1(ChooseFrameModel)
        case basicFrame4x1(ChooseFrameModel)
        case basicFrame4x1Emoji(ChooseFrameModel)
        case basicFrame4x1Mongle(ChooseFrameModel)
    }
    typealias DiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<ChooseFrameModel.Category, Item>
    
    // MARK: - ReactorKit
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case didTap나가기버튼뷰
        case didTapCellGesture(ChooseFrameModel)
        case 고르기완료버튼
    }
    
    enum Mutation {
        case isDismiss
        case fetchSnapshot
        case modelSelected(ChooseFrameModel)
        case showsNextView(Bool)
    }
    
    struct State {
        var neCutMakeType: NeCutMakeType
        enum NextViewType {
            case 카메라, 포토컷
        }
        let nextViewType: NextViewType // 외부에서 받아온 타입 - RxFlow로 개선하기
        
        var photoFrames: [ChooseFrameModel] = ChooseFrameModel.photoFrames
        
        var snapshot = DiffableDataSourceSnapshot()
        
        var chooseFrameModelItem: ChooseFrameModel {
            didSet {
                print("🐶 \(chooseFrameModelItem)")
            }
        }// 선택한 프레임 모델
        @Pulse var showsNextView: Bool = false
        var isDismiss: Bool = false
        
        init(neCutMakeType: NeCutMakeType, nextViewType: NextViewType) {
            self.neCutMakeType = neCutMakeType
            self.nextViewType = nextViewType
            
            let item = photoFrames.filter { model in
               model.isChoose == true
            }.first!
            
            self.chooseFrameModelItem = item
        }
    }
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.fetchSnapshot)
        case .viewWillAppear:
            return .just(.showsNextView(false))
        case .didTap나가기버튼뷰:
            return .just(.isDismiss)
        case .didTapCellGesture(let model):
            return .just(.modelSelected(model))
        case .고르기완료버튼:
            return .just(.showsNextView(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .isDismiss:
            newState.isDismiss = true
            return newState
        case .fetchSnapshot:
            newState.snapshot = self.fetchSnapshot(currentState.photoFrames)
            return newState
        case .modelSelected(let model):
            newState.photoFrames = self.updatePhotoFrames(item: model)
            newState.snapshot = self.fetchSnapshot(newState.photoFrames)
            
            newState.chooseFrameModelItem = model
            
            return newState
        case .showsNextView(let isValue):
            newState.isDismiss = false
            newState.showsNextView = isValue
            
            return newState
        }
    }
    
    private func updatePhotoFrames(item: ChooseFrameModel) -> [ChooseFrameModel] {
        var frames = currentState.photoFrames
        
        frames.enumerated().forEach { offset, model in
            if model.id == item.id {
                frames[offset].isChoose = true
            } else {
                frames[offset].isChoose = false
            }
        }
        
        return frames
    }
    
    private func fetchSnapshot(_ frames: [ChooseFrameModel]) -> DiffableDataSourceSnapshot {
        var snapshot = currentState.snapshot
        
        snapshot.deleteAllItems()
        snapshot.appendSections(ChooseFrameModel.Category.allCases)
        
        frames.forEach { model in
            switch model.category {
            case .basicFrame4x1:
                snapshot.appendItems([.basicFrame1x1(model)], toSection: .basicFrame4x1)
            case .basicFrame1x1:
                snapshot.appendItems([.basicFrame4x1(model)], toSection: .basicFrame1x1)
            case .basicFrame1x1Emoji:
                snapshot.appendItems([.basicFrame4x1(model)], toSection: .basicFrame1x1Emoji)
            case .basicFrame4x1Mongle:
                snapshot.appendItems([.basicFrame4x1Mongle(model)], toSection: .basicFrame4x1Mongle)
            }
        }
        
        return snapshot
    }
    
    private func updateChoosePhoto() {
        
    }
}
