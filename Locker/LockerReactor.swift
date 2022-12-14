//
//  LockerReactor.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/29.
//

import UIKit
import SwiftUI
import ReactorKit

final class LockerReactor: Reactor {
    enum Action {
        case viewWillAppear
        case didTapXmark
        case didTapPlus
        case itemSelected(IndexPath)
        case didFinishPicking(UIImage)
    }
    
    enum Mutation {
        case fetchService
        case isDismiss
        case isShowingPicker
        case itemSelected(IndexPath)
        case appendImage(UIImage)
    }
    
    struct State {
        @Pulse var lockerModels: [LockerModel] = []
        var isDismiss: Bool = false
        @Pulse var isHiddenEmptyLabel: Bool = false
        
        @Pulse var showsPicker: Bool = false
        @Pulse var showDetailView: (Bool, IndexPath) = (false, .init())
    }
    
    let fileManager = ImageFileManager.shared
    let appStorageManager = AppStorageManager.shared
    
    var initialState: State
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .just(.fetchService)
        case .didTapXmark:
            return .just(.isDismiss)
        case .didTapPlus:
            return .just(.isShowingPicker)
        case .itemSelected(let indexPath):
            return .just(.itemSelected(indexPath))
        case .didFinishPicking(let image):
            return .just(.appendImage(image))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .fetchService:
            newState.lockerModels = appStorageManager.lockerModels
            isHiddenState(newState: &newState)

            return newState
        case .isDismiss:
            newState.isDismiss = true
            
            return newState
        case .isShowingPicker:
            newState.showsPicker = true
            
            return newState
        case .itemSelected(let indexPath):
            newState.showDetailView = (true, indexPath)
            
            return newState
        case .appendImage(let image):
            newState.lockerModels = self.appendImage(image: image)
            isHiddenState(newState: &newState)
            
            return newState
        }
    }
    
    private func isHiddenState(newState : inout State) {
        newState.isHiddenEmptyLabel = newState.lockerModels.count == 0
        ? false
        : true
    }
    
    private func appendImage(image: UIImage) -> [LockerModel] {
        var cuurentImages = currentState.lockerModels
        let lockerModel = LockerModel()
        
        cuurentImages.append(lockerModel)
        
        // 1. 로컬 디바이스에 데이터 저장
        appStorageManager.lockerModels.append(lockerModel)
        fileManager.saveImage(id: lockerModel.id, image: image)
        ImageManager().appendImage(id: lockerModel.id, image: image)
        
        return cuurentImages
    }
}
