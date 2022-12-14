//
//  ChoosePhotoReactor.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/27.
//

import UIKit
import ReactorKit

final class ChoosePhotoReactor: Reactor {
    typealias MakeType = NeCutMakeManager.NeCutMakeType
    
    enum Action {
        case viewWillAppear
        case didTapBack
        case didTap고르기완료버튼
        case modelSelected(ChoosePhotoModel)
    }
    
    enum Mutation {
        case isDismiss
        case isShowNext(Bool)
        case updateIsChoose(ChoosePhotoModel)
    }
    
    struct State {
        let makeType: MakeType
        var capturePhotos: [ChoosePhotoModel]
        var frameImage: UIImage
        
        var choosePhotos: [ChoosePhotoModel] = []
        var isDismiss: Bool = false
        @Pulse var isEnabledConfirmButton: Bool = false
        var isShowNext: Bool = false
        
        init(capturePhotos: [ChoosePhotoModel], frameImage: UIImage, makeType: MakeType) {
            self.capturePhotos = capturePhotos
            self.frameImage = frameImage
            self.makeType = makeType
        }
    }
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .just(.isShowNext(false))
        case .didTapBack:
            return .just(.isDismiss)
        case .didTap고르기완료버튼:
            return .just(.isShowNext(true))
        case let .modelSelected(model):
            return .just(.updateIsChoose(model))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .isDismiss:
            newState.isDismiss = true
            return newState
        case .isShowNext(let isValue):
            newState.isShowNext = isValue
            
            return newState
        case let .updateIsChoose(model):
            let updatePhotos = self.updateChoosePhotos(model: model)
            
            newState.choosePhotos = updatePhotos.0
            newState.capturePhotos = updatePhotos.1
            
            newState.isEnabledConfirmButton = self.isEnabledConfirmButton(choosePhotos: updatePhotos.0)
            
            return newState
        }
    }
    
    private func updateChoosePhotos(model: ChoosePhotoModel) -> ([ChoosePhotoModel], [ChoosePhotoModel]) {
        
        var capturePhotos = currentState.capturePhotos
        var choosePhotos = currentState.choosePhotos
        
        let type = initialState.makeType
        let maxCount: Int
        switch type {
        case .basic_frame_1x1, .basic_frame_1x1_emoji: maxCount = 1
        case ._4by2, .basic_frame_4x1, .basic_frame_4x1_mongle: maxCount = 4
        }
        
        if !choosePhotos.contains(where: { $0.id == model.id }) { // 선택된 사진이 아니라면
            print("없는 사진이에요.")
            if choosePhotos.count < maxCount { // 선택된 사진의 갯수가 4 미만이라면
                choosePhotos.append(model) // choosePhotos의 끝 부분에 추가하기
            } else { // 선택된 사진의 갯수가 4 이상이라면
                // NOTE: - 추가하지 않기
            }
        } else { // 선택된 사진이라면
            print("이미 들어있는 사진이에요.")
            choosePhotos.removeAll { photo in photo.id == model.id } // 해당하는 사진 삭제
        }
        
        capturePhotos.enumerated().forEach { offset, capture in
            if let index = choosePhotos.firstIndex(where: { $0.id == capture.id }) {
//                print("☃️ \(capture) :: \(index) ")
                capturePhotos[offset].chooseOrder = index + 1
            } else {
//                print("☃️ \(capture) :: 널입니다. 존재하지 않아요. ")
                capturePhotos[offset].chooseOrder = nil
            }
        }
        
        return (choosePhotos, capturePhotos)
    }
    
    private func isEnabledConfirmButton(choosePhotos: [ChoosePhotoModel]) -> Bool {
        let type = initialState.makeType
        
        switch type {
        case .basic_frame_4x1, ._4by2, .basic_frame_4x1_mongle:
            return choosePhotos.count >= 4
            ? true
            : false
        case .basic_frame_1x1, .basic_frame_1x1_emoji:
            return choosePhotos.count >= 1
            ? true
            : false
        }
    }
}
