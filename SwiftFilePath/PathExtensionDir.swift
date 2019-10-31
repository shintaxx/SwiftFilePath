//
//  Dir.swift
//  SwiftFilePath
//
//  Created by nori0620 on 2015/01/08.
//  Copyright (c) 2015年 Norihiro Sakamoto. All rights reserved.
//
import Foundation
// Instance Factories for accessing to readable iOS dirs.
#if os(iOS)
extension Path {
    
    public class var homeDir: Path {
        return Path(NSHomeDirectory())
    }
    
    public class var temporaryDir: Path {
        return Path(NSTemporaryDirectory())
    }
    
    public class var documentsDir:Path {
        return Path.userDomainOf(.documentDirectory)
    }
    
    public class var cacheDir:Path {
        return Path.userDomainOf(.cachesDirectory)
    }
    
    fileprivate class func userDomainOf(_ pathEnum: FileManager.SearchPathDirectory) -> Path {
        let pathString = NSSearchPathForDirectoriesInDomains(pathEnum, .userDomainMask, true)[0] 
        return Path(pathString)
    }
    
}
#endif

// Add Dir Behavior to Path by extension
extension Path: Sequence {
    
    public subscript(filename: String) -> Path {
        get { return self.content(filename) }
    }

    public var children: Array<Path>? {
        assert(self.isDir,"To get children, path must be dir< \(path_string) >")
        assert(self.exists,"Dir must be exists to get children.< \(path_string) >")

        do {
            let contents = try self.fileManager.contentsOfDirectory(atPath: path_string)
            return contents.map(content)
        } catch let error as NSError {
            print("Error< \(error.localizedDescription) >")
            return nil
        }
    }
    
    public var contents: Array<Path>? {
        return self.children
    }
    
    public func content(_ path_string: String) -> Path {
        let s = (self.path_string as NSString).appendingPathComponent(path_string)
        return Path(s)
    }
    
    public func child(_ path: String) -> Path {
        return self.content(path)
    }
    
    public func mkdir() -> Path.Result<Path, NSError> {

        do {
            try fileManager.createDirectory(atPath: path_string,
                        withIntermediateDirectories:true,
                            attributes:nil)
            return Path.Result(success: self)
        } catch let error as NSError {
            return Path.Result(failure: error)
        }
    }
    
    public func makeIterator() -> AnyIterator<Path> {
        assert(self.isDir,"To get iterator, path must be dir< \(path_string) >")
        let iterator = fileManager.enumerator(atPath: path_string)
        return AnyIterator() {
            let optionalContent = iterator?.nextObject() as? String
            if let content = optionalContent {
                return self.content(content)
            } else {
                return .none
            }
        }
    }
    
}
