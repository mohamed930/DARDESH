//
//  FileManagerLayer.swift
//  DARDESH
//
//  Created by Mohamed Ali on 27/08/2021.
//

import Foundation

class FileManagerLayer {
    
    static let shared = FileManagerLayer()
    
    // MARK:- TODO:- This Method For Get Documnt URL from FileManager.
    func GetDoucumntURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).last!
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method for make file in the directory we get it path and return path for this file.
    func fileInDocumntDirectory(fileName: String) -> String {
        return GetDoucumntURL().appendingPathComponent(fileName).path
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Checking if file is exsist or not.
    func fileExsistsAtPath (path: String) -> Bool {
        return FileManager.default.fileExists(atPath: fileInDocumntDirectory(fileName: path))
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Mathod For Saving Img to FileManager Locally.
    func SaveFileLocally (fileData: NSData, fileName: String) {
        let docUrl = GetDoucumntURL().appendingPathComponent(fileName, isDirectory: false)
        
        fileData.write(to: docUrl, atomically: true)
    }
    // ------------------------------------------------
    
}
