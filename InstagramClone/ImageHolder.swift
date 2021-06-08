//
//  ImageHolder.swift
//  InstagramClone
//
//  Created by Kaushal Topinkatti B on 08/06/21.
//

import Foundation
import UIKit

struct ImageHolder {
    
    var image: UIImage
    var completion: (UIImage)->()
    
    init() {
        image = UIImage()
        completion = {result in
            
        }
    }
    
    mutating func setImg(img:UIImage) {
        image = img
        completion(img)
    }
    
    func getImg() -> UIImage {
        return image
    }
    
    mutating func setCallback(newCompletion: @escaping (UIImage)->()) {
        self.completion = newCompletion
    }
    
    func getCallback() -> (UIImage)->() {
        return completion
    }
}
