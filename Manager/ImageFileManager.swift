//
//  ImageFileManager.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/11/28.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()

    private init() {
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if #available(iOS 16.0, *) {
            print("👉 이미지 File Url :: \(url[0].path())")
        } else {
            // Fallback on earlier versions
        }
    }
    
    private let fileManager = FileManager.default
    private lazy var documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    private let folderName = "HomePhoto"
    private lazy var folderURL = documentURL.appendingPathComponent(folderName, conformingTo: .image)
    
    // 특정사진 저장하기
    @discardableResult
    func saveImage(id: String, image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        
        guard let directory = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) as NSURL else { return false }
        
        do {
            try data.write(to: directory.appendingPathComponent(id)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
//
    // 특정사진 불러오기
    func getSavedImage(id: String) -> UIImage? {

        if let folder = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) {
            let url = URL(fileURLWithPath: folder.absoluteString)
                .appendingPathComponent(id).path

            return UIImage(contentsOfFile: url)
        }
        return nil
    }
}

