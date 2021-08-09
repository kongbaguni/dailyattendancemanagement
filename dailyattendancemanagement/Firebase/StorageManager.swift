//
//  StorageManager.swift
//  dailyattendancemanagement
//
//  Created by Changyeol Seo on 2021/08/09.
//

import Foundation
import Firebase
import FirebaseStorage
import AlamofireImage

struct FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    let storageRef = Storage.storage().reference()
    
    func uploadImage(fileUrl url:URL, uploadSize:CGSize, uploadURL:String, complete:@escaping(_ downloadURL:URL?)->Void) {
        guard var data = try? Data(contentsOf: url) else {
            complete(nil)
            return
        }
        if let image = UIImage(data: data) {
            if let newData = image.af.imageScaled(to: image.size.resize(target: uploadSize, isFit: true)).jpegData(compressionQuality: 0.7) {
                data = newData
            }
        }
        
        let ref:StorageReference = storageRef.child(uploadURL)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let task = ref.putData(data, metadata: metadata)
        task.observe(.success) { (snapshot) in
                    let path = snapshot.reference.fullPath
                    print(path)
                    ref.downloadURL { (downloadUrl, err) in
                        if (downloadUrl != nil) {
                            print(downloadUrl?.absoluteString ?? "없다")
                        }
                        complete(downloadUrl)
                    }
                }
        task.observe(.failure) { (_) in
            complete(nil)
        }
    }
}
