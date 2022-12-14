//
//  CameraPreview.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/26.
//

import UIKit
import AVFoundation

final class CameraPreviewView: UIView {
    
    var defaultVideoDevice: AVCaptureDevice? // 외부에서 back인지 front인지 알아야 하니까
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var sessionQueue = DispatchQueue(label: "sessionQueue")
    var captureSession = AVCaptureSession()
    var deviceInput : AVCaptureDeviceInput!
    var photoOutput: AVCapturePhotoOutput!
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera],
        mediaType: .video,
        position: .unspecified
    )
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // MARK: - Initialize
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(sender: UIView) {
        self.init(frame: .zero)
        
        self.configurePreviewLayer(sender: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func configurePreviewLayer(sender: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        sender.layer.addSublayer(previewLayer)
        
        // NOTE: - startRunning은 blocking call이라서 main block 되지 않도록 queue로 처리
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.captureSession.startRunning()
            
            DispatchQueue.main.async {
                self.previewLayer.frame = sender.bounds
            }
            
            self.configureCaptureSession()
        }
    }
    
    /// 카메라 방향을 변경합니다.
    func switchCamera(postion: AVCaptureDevice.Position) {
        guard videoDeviceDiscoverySession.devices.count > 1 else {
            print("🚨 videoDeviceDiscoverySession not found")
            return
        }
        
        sessionQueue.async {
            let currentvideoDevice = self.deviceInput.device // 현재 디바이스의 인풋
            
            let currentPosition = currentvideoDevice.position // 현재 디바이스의 앞, 뒤 방향
//            let isFornt = currentPosition == .front // 전면 카메라인가?
//            let preferredPosition : AVCaptureDevice.Position = isFornt ? .back : .front
//            
            let devices = self.videoDeviceDiscoverySession.devices
            
            self.defaultVideoDevice = devices.first(where: { device in
                return postion == device.position
            })
            
            
            if let newDevice = self.defaultVideoDevice {
                do {
                    
                    let videoDeviceInput = try AVCaptureDeviceInput(device: newDevice)
                    self.captureSession.beginConfiguration()
                    self.captureSession.removeInput(self.deviceInput)
                    
                    if self.captureSession.canAddInput(videoDeviceInput) {
                        self.captureSession.addInput(videoDeviceInput)
                        self.deviceInput = videoDeviceInput
                    } else {
                        self.captureSession.addInput(videoDeviceInput)
                    }
                    self.captureSession.commitConfiguration()
                    
                } catch let error{
                    print("🚨 error occured while creating device input : \(error.localizedDescription)")
                }
                
            }
        }
    }
    
    private func configureCaptureSession() {
        
        // MARK: - Configure Session
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        
        do {
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let camera = videoDeviceDiscoverySession.devices.first else {// 여기에서 찾은게 있으면 첫번째꺼 가져옴 - 핸드폰에서 카메라를 찾을떄, videoDeviceDiscoverySession 중 제일 마지막 파라미터에 명시된 부분을 찾으라는 의미
                captureSession.commitConfiguration() // 못찾았으면 그냥 종료하게끔
                return
            }
//            let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
            
            // MARK: - Input
            let input = try AVCaptureDeviceInput(device: camera)
            photoOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                self.deviceInput = input
            } else {
                captureSession.commitConfiguration()
                return
            }
            
            // MARK: - Output
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            } else {
                captureSession.commitConfiguration()
                return
            }
            
        } catch {
            captureSession.commitConfiguration()
            print("🚨 \(error.localizedDescription)")
        }
        
        captureSession.commitConfiguration()
    }
    
    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        var videoPreviewLayerOrientation = previewLayer.connection?.videoOrientation
        
        videoPreviewLayerOrientation = .portrait
        
        sessionQueue.async {
            let connection = self.photoOutput.connection(with: .video)
            connection?.videoOrientation = videoPreviewLayerOrientation!
            
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            
            self.photoOutput.capturePhoto(with: settings, delegate: delegate)
        }
    }
}
