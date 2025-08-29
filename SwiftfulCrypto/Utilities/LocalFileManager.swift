//
//  LocalFileManager.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/31/25.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    //can't save image to File manager so we save the Data of an image instead
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        //create folder
        createFolderIfNeeded(folderName: folderName)
        
        //get path for image
        guard let data = image.pngData(),
        let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {
            return
        }
        
        //save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    //before a file is saved we must make sure that the folder has been
    //created first. This must be called before saving an image
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName)
        else {
            return
        }
        //if the folder path doesn't exist, create the directory
        if !FileManager.default.fileExists(atPath: url.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    //get url for the folder we are going to save the image to
    //this returns the folder directory with a backslash and folder name
    private func getURLForFolder(folderName: String) -> URL? {
        
        //url is optional so guard let it
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
            return nil
        }
        
        //append the folder name
        //returns the folder url
        return url.appendingPathComponent(folderName)
    }
    
    //get the url where we want to save the image inside the folder
    //this function appends a backslash and image name to the folder
    //directory path
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName)
        else {
            return nil
        }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
