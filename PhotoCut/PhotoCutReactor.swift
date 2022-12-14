//
//  PhotoCutReactor.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit
import ReactorKit

final class PhotoCutReactor: Reactor {
    typealias MakType = NeCutMakeManager.NeCutMakeType
    
    enum Action {
        case didTapXmark
        case itemSelected(IndexPath)
        case didFinishImagePicker(UIImage)
    }
    
    enum Mutation {
        case isDismiss
        case itemSelected(IndexPath)
        case didFinishImagePicker(UIImage)
        case isEnabled고르기완료
    }
    
    struct State {
        var makeType: MakType
        var frmaeImage: UIImage
        
        var dataSource: [PhotoCutModel] = [] {
            didSet { print("🪰 \(dataSource)") }
        }
        
        var selectedIndexPath: IndexPath?
        @Pulse var showImagePickerController: Bool = false
        var isDismiss: Bool = false
        var isEnabled고르기완료: Bool = false
        
        init(makeType: MakType, frmaeImage: UIImage) {
            self.makeType = makeType
            self.frmaeImage = frmaeImage
                        
            switch makeType {
            case .basic_frame_1x1, .basic_frame_1x1_emoji:
                (1...1).forEach { _ in self.dataSource.append(PhotoCutModel()) }
            case .basic_frame_4x1, ._4by2, .basic_frame_4x1_mongle:
                (1...4).forEach { _ in self.dataSource.append(PhotoCutModel()) }
            
            }
        }
    }
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapXmark:
            return .just(.isDismiss)
        case .itemSelected(let indexPath):
            return .just(.itemSelected(indexPath))
        case .didFinishImagePicker(let image):
            return .concat([
                .just(.didFinishImagePicker(image)),
                .just(.isEnabled고르기완료)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .isDismiss:
            newState.isDismiss = true
            return newState
        case .itemSelected(let indexPath):
            newState.showImagePickerController = true
            newState.selectedIndexPath = indexPath
            
            return newState
        case .didFinishImagePicker(var image):

            image = self.downSamplingAndCrop(image: image)
            newState.showImagePickerController = false
            
            let newDataSource = self.updateDataSource(image: image)
            newState.dataSource = newDataSource
            
            return newState
        case .isEnabled고르기완료:
            let type = initialState.makeType
            let tt = currentState.dataSource.compactMap { item in
                item.image
            }
            
            switch type {
            case .basic_frame_4x1, ._4by2, .basic_frame_4x1_mongle:
                if tt.count >= 4 { newState.isEnabled고르기완료 = true }
            case .basic_frame_1x1, .basic_frame_1x1_emoji:
                if tt.count >= 1 { newState.isEnabled고르기완료 = true }
            }
            
//            newState.isEnabled고르기완료 = true
            return newState
        }
    }
    
    private func updateDataSource(image: UIImage) -> [PhotoCutModel] {
        var dataSource = currentState.dataSource
        
        if let indexPath = currentState.selectedIndexPath {
            let index = indexPath.row
            
            dataSource[index] = PhotoCutModel(image: image)
        } else {
            print("어? 여기에 들어오면 안되는데..")
        }
        
        return dataSource
    }
    
    func downSamplingAndCrop(image: UIImage) -> UIImage {
        let makeType = currentState.makeType
        
        // TODO: - 함수형 프로그래밍을 도입하면 얼마나 행복할까 - 커링의 개념을 공부해야합니다.
        var image = image
        image = image.downSampling(makeType: makeType)
        image = image.cropImage(makeType: makeType)
        
        return image
    }
}
