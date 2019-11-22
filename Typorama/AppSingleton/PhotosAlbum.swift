//
//  PhotosAlbum.swift
//  Typorama
//
//  Created by Apple on 13/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//
/*

DispatchQueue.global(qos: .default).async(execute: {
    
    DispatchQueue.main.async(execute: {
 
    })
})
*/


import UIKit
import Photos

class PhotosAlbum: NSObject {
    
    var requestOptions: PHImageRequestOptions?
    var manager: PHCachingImageManager?
    var requestId: PHImageRequestID = 0
    
    var mainCollection : PHAssetCollection?
    
    
    static var instance: PhotosAlbum!
    
    class func shared() -> PhotosAlbum {
        
        self.instance = (self.instance ?? PhotosAlbum())
        
        return self.instance
    }
    
    func checkPhotosLibraryPermission(Handler:@escaping (_ code: Bool) -> Void) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized {
            
            Handler(true)
        }
        else if status == .denied {
            
            Handler(false)
        }
        else if status == .notDetermined {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ status in
                
                if status == .authorized {
                    
                    Handler(true)
                } else {
                    
                    Handler(false)
                }
            })
        } else if status == .restricted {
            
            Handler(false)
        }
    }
    
    func getAllImagesFromPhotos(Handler:@escaping (_ code: Bool, _ results: PHFetchResult<PHAsset>?) -> Void) {
        
        self.checkPhotosLibraryPermission { (granted) in
            
            if granted == true {
            
                if self.mainCollection == nil {
                
                    self.getMainAlbum(Handler: { (collection) in
                        
                        self.mainCollection = collection
                        self.getMainAlbumPic(granted: granted, Handler: Handler)
                    })
                }
                else {
                
                    self.getMainAlbumPic(granted: granted, Handler: Handler)
                }
            }
            else {
            
                Handler(granted, nil)
            }
//            var allPhotos : PHFetchResult<PHAsset>? = nil
//            if granted == true {
//
//                let fetchOptions = PHFetchOptions()
//                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//            }
//            
        }
    }
    
    func getMainAlbum(Handler:@escaping (_ collection: PHAssetCollection) -> Void) {
     
        self.requestOptions = PHImageRequestOptions()
        self.requestOptions?.isNetworkAccessAllowed = true
        self.requestOptions?.isSynchronous = true
        self.manager = PHCachingImageManager()
        
        let fetchOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
        
        smartAlbums.enumerateObjects({ obj, idx, stop in
            
            if obj.assetCollectionSubtype == .smartAlbumUserLibrary {
                
                Handler(obj)
            }
        })
    }
    
    func getMainAlbumPic(granted: Bool, Handler:@escaping (_ code: Bool, _ results: PHFetchResult<PHAsset>?) -> Void) {
     
        let collectionResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.mainCollection?.localIdentifier].compactMap { $0 }, options: nil)
        
        collectionResult.enumerateObjects({ collection, idx, stop in
            
            let opts = PHFetchOptions()
            opts.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let collectionResult = PHAsset.fetchAssets(in: collection, options: opts)
            
            Handler(granted, collectionResult)
        })
    }
    
    func fetchImage(asset: PHAsset, targetSize: CGSize, Handler:@escaping (_ image: UIImage?) -> Void) {

        DispatchQueue.global(qos: .default).async(execute: {
            
            self.requestOptions?.isNetworkAccessAllowed = true
            self.requestId = self.manager!.requestImageData(for: asset, options: self.requestOptions, resultHandler: { (data, str, ori, info) in
                
                if let data = data, let img = UIImage(data: data){
                    DispatchQueue.main.async(execute: {
                        
                        Handler(img)
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        
                        Handler(nil!)
                    })
                }
            })
//            self.requestId = self.manager!.requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: self.requestOptions, resultHandler: { image, info in
//
//
//            })
        })
    }
    
    func savePhoto(image: UIImage, InAlbum name: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        
        self.checkPhotosLibraryPermission { (granted) in

            if granted == true {

                self.findAlbum(image: image, InAlbum: name, completionBlock: completionBlock)
            }
            else {
             
                completionBlock(granted)
            }
        }
    }
    
    func getAlbum(name: String) -> PHAssetCollection? {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let Albums = PHCollectionList.fetchTopLevelUserCollections(with: fetchOptions)
        
        if Albums.count > 0 {
            
            return (Albums.firstObject as! PHAssetCollection)
        }
        else {
            
            return nil
        }
    }
    
    var albumPlaceholder: PHAssetCollection!
    
    func findAlbum(image: UIImage, InAlbum name: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        
        let album = self.getAlbum(name: name)
        
        if album == nil {
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            }) { success, _ in
                
                if success {
                    
                    self.add(image: image, InAlbum: self.getAlbum(name: name)!, completionBlock: completionBlock)
                }
                else {
                    
                    completionBlock(false)
                }
            }
        }
        else {
            
            self.add(image: image, InAlbum: album!, completionBlock: completionBlock)
        }
    }
    
    func add(image: UIImage, InAlbum album: PHAssetCollection, completionBlock: @escaping (_ success: Bool) -> Void) {
        
        PHPhotoLibrary.shared().performChanges({
            
            let path = AppSingletonObj.getPath(filename: "temp.png")
            AppSingletonObj.writeFile(filePath: path, data: image.pngData() as NSData?)
            
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: path))
            let assetPlaceholder = createAssetRequest?.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            albumChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)
        }, completionHandler: { success, error in
            
            if success {
                
                completionBlock(true)
            }
            else {
                
                completionBlock(false)
            }
        })
    }
}

