//
//  LockerDetailReactor.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/03.
//

import Foundation
import ReactorKit

final class LockerDetailReactor: Reactor {
    enum Action {
        case viewDidLoad
        case didTapBack
        case didTapPencil
        case didTapConfirm(String)
        case didTapTrash
    }
    
    enum Mutation {
        case viewDidLoad
        case isDismiss
        case isEditing
        case removeModel
        case updateText(String)
    }
    
    struct State {
        let indexPath: IndexPath
        
        @Pulse var lockerModel: LockerModel?
        
        var isDismiss: Bool = false
        var isEditing: Bool = false
        
        init(indexPath: IndexPath) {
            self.indexPath = indexPath
        }
    }
    
    let appStorageManager = AppStorageManager.shared
    let imageFileManager = ImageFileManager.shared
    
    var initialState: State
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.viewDidLoad)
        case .didTapBack:
            return .just(.isDismiss)
        case .didTapPencil:
            return .just(.isEditing)
        case .didTapConfirm(let text):
            return .concat([
                .just(.isEditing),
                .just(.updateText(text))
            ])
        case .didTapTrash:
            return .just(.removeModel)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .viewDidLoad:
            let index = currentState.indexPath.row
            let model = appStorageManager.lockerModels[index]
            
            newState.lockerModel = model
            
            return newState
        case .isDismiss:
            newState.isDismiss = true
            
            return newState
        case .isEditing:
            newState.isEditing = !newState.isEditing
            
            return newState
        case .removeModel:
            self.removeItem()
            newState.isDismiss = true
            
            return newState
        case .updateText(let text):
            newState.lockerModel = fetchModel(text: text)
            return newState
        }
    }
    
    func fetchModel(text: String) -> LockerModel {
        var model = currentState.lockerModel
        model?.text = text
        
        let index = currentState.indexPath.row
        appStorageManager.lockerModels[index] = model!
        
        return model ?? LockerModel()
    }
    
    func removeItem() {
        let index = currentState.indexPath.row
        appStorageManager.lockerModels.remove(at: index)
    }
}
