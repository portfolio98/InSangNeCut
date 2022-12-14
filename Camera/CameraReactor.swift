//
//  CameraReactor.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/30.
//

import UIKit
import ReactorKit
import AVFoundation

final class CameraReactor: Reactor {
    typealias MakeType = NeCutMakeManager.NeCutMakeType
    
    enum Action {
        case viewWillAppear
        case didTapBack
        case didTapCheckmark
        case didTap촬영하기버튼뷰
        case didTapimageOrientationImageView
        case didTapSwitchCameraImageView
        case didFinishProcessingPhoto(UIImage)
    }
    
    enum Mutation {
        case viewWillAppear
        case isDismiss
        case isProcessingPhoto(Bool)
        case imageOrientation
        case switchCamera
        case showsChoosePhotoView
        case capture(UIImage)
    }
    
    struct State {
        let makeType: MakeType
        let frameImage: UIImage
        
        var isDismiss = false
        @Pulse var isProcessingPhoto = false // 카메라 사진 output 처리중인지
        var isHiddenCheckmark = true // 체크마크 히든
        var showsChoosPhotoView: (Bool, [UIImage], UIImage)
        var capturePhotos: [UIImage] = []
        @Pulse var imageOrientationIndex: Int = 0 // 이미지 방향 오리엔테이션
        @Pulse var hardwarePostion: AVCaptureDevice.Position = .back // 카메라 하드웨어 포지션
        
        init(frameImage: UIImage, makeType: MakeType) {
            self.frameImage = frameImage
            self.showsChoosPhotoView = (false, [], frameImage)
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
            return .just(.viewWillAppear)
        case .didTapBack:
            return .just(.isDismiss)
        case .didTapCheckmark:
            return .just(.showsChoosePhotoView)
        case .didTap촬영하기버튼뷰:
            return .just(.isProcessingPhoto(true))
        case .didTapimageOrientationImageView:
            return .just(.imageOrientation)
        case .didTapSwitchCameraImageView:
            return .just(.switchCamera)
        case .didFinishProcessingPhoto(let image):
            return .concat([
                .just(.capture(image)),
                .just(.isProcessingPhoto(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .viewWillAppear:
            newState.showsChoosPhotoView = (false, [], .init())
            
            return newState
        case .isDismiss:
            newState.isDismiss = true
            
            return newState
        case .imageOrientation:
            var index = currentState.imageOrientationIndex
            index += 1
            if index >= UIImage.Orientation.frontOrientations.count { // 초과했다면
                index = 0
            }
            
            newState.imageOrientationIndex = index
            return newState
        case .switchCamera:
            let oldValue = currentState.hardwarePostion
            
            newState.hardwarePostion = oldValue == .back
            ? .front
            : .back
            
            return newState
        case .showsChoosePhotoView:
            let images = currentState.capturePhotos
            let frameImage = currentState.frameImage
            newState.showsChoosPhotoView = (true, images, frameImage)
            
            return newState
        case .isProcessingPhoto(let value):
            newState.isProcessingPhoto = value
            
            return newState
        case .capture(let image):
            var photos = currentState.capturePhotos
            let index = currentState.imageOrientationIndex
            
            var orientations: [UIImage.Orientation]
            let hardwarePosition = currentState.hardwarePostion
            
            orientations = hardwarePosition == .back
            ? UIImage.Orientation.backOrientations
            : UIImage.Orientation.frontOrientations
            
            var cropImage: UIImage
            switch currentState.makeType {
            case .basic_frame_1x1_emoji, .basic_frame_1x1: cropImage = image.cropImage1x1()
            default: cropImage = image.cropImage4x1()
            }

            let newImage = UIImage(cgImage: cropImage.cgImage!,
                                   scale: cropImage.scale,
                                   orientation: orientations[index])
            
            photos.append(newImage)
            newState.capturePhotos = photos
            
            newState.isHiddenCheckmark = self.isHiddenCheckButton(photos: photos)
            
            return newState
        }
    }
    
    private func isHiddenCheckButton(photos: [UIImage]) -> Bool {
        let type = currentState.makeType
        switch type {
        case .basic_frame_1x1, .basic_frame_1x1_emoji:
            return photos.count >= 1
            ? false
            : true
        case ._4by2, .basic_frame_4x1, .basic_frame_4x1_mongle:
            return photos.count >= 4
            ? false
            : true
        }
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
