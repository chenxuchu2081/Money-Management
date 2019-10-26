//
//  StorageService.swift
//  Money Management
//
//  Created by CHEN Xuchu on 28/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import UIKit
import FirebaseStorage

//import FirebaseDatabase

struct StorageService {
    // provide method for uploading images
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion(nil)
        }

        // 2
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }

            // 4
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
}

struct PostService {

    static func create(for image: UIImage){
        let randomId = UUID.init().uuidString
        let imageRef = Storage.storage().reference(withPath: "images/\(randomId).jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }

            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }

    }
}
