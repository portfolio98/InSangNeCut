//
//  ImageManager.swift
//  InsangNeCut
//
//  Created by Hamlit Jason on 2022/12/13.
//
//error build: Multiple commands produce '/Users/hamlitjason/Library/Developer/Xcode/DerivedData/InsangNeCut-bynjmshghwnxufgrxbhpxkfiptil/Build/Intermediates.noindex/InsangNeCut.build/Debug-iphoneos/InsangNeCut.build/Objects-normal/arm64/ConfigurationIntent.stringsdata'

import SwiftUI
import WidgetKit

struct Helper {
    
    static func getImageIdsFromUserDefault() -> [String] {
        
        if let userDefaults = UserDefaults(suiteName: AppStorageKey.suiteName.rawValue) {
            if let data = userDefaults.data(forKey: AppStorageKey.photosKey.rawValue) {
                return try! JSONDecoder().decode([String].self, from: data)
            }
        }
        
        return [String]()
    }
    
    static func getImageFromUserDefaults(key: String) -> UIImage {
        if let userDefaults = UserDefaults(suiteName: AppStorageKey.suiteName.rawValue) {
            if let imageData = userDefaults.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return UIImage(systemName: "photo.fill.on.rectangle.fill")!
    }
}


final class ImageManager: NSObject, ObservableObject {
    
    @Published var photos = [String]()
    
    // MARK: - SETUP
    override init() {
        super.init()
        
        photos = Helper.getImageIdsFromUserDefault()
    }
    
    func appendImage(id: String, image: UIImage) {
        print("🔥 id \(id)")
        // Save image in userdefaults
        if let userDefaults = UserDefaults(suiteName: AppStorageKey.suiteName.rawValue) {
            
            if let jpegRepresentation = image.jpegData(compressionQuality: 0.5) {
                
//                let id = UUID().uuidString
                userDefaults.set(jpegRepresentation, forKey: id)
                
                // Append the list and save
                photos.append(id)
                saveIntoUserDefaults()
                
                // Notify the widget to reload all items
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
    private func saveIntoUserDefaults() {
        if let userDefaults = UserDefaults(suiteName: AppStorageKey.suiteName.rawValue) {
            
            let data = try! JSONEncoder().encode(photos)
            userDefaults.set(data, forKey: AppStorageKey.photosKey.rawValue)
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
}
