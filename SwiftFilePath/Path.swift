//
//  Path.swift
//  SwiftFilePath
//
//  Created by nori0620 on 2015/01/08.
//  Copyright (c) 2015年 Norihiro Sakamoto. All rights reserved.
//

open class Path {
    
    // MARK: - Class methods
    
    open class func isDir(_ path: String) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory:&isDirectory)
        
        return isDirectory.boolValue ? true : false
    }
    
    // MARK: - Instance properties and initializer
    
    lazy var fileManager = FileManager.default
    public let path_string:String
    
    
    public init(_ p: String) {
        self.path_string = p
    }
    
    // MARK: - Instance val
    
    open var attributes: [FileAttributeKey : Any] {
        get { return self.loadAttributes() }
    }
    
    open var asString: String {
        return path_string
    }
    
    open var asFileURL: URL? {
        return URL(fileURLWithPath: path_string, isDirectory: isDir)
    }
    
    open var exists: Bool {
        return fileManager.fileExists(atPath: path_string)
    }
    
    open var isDir: Bool {
        return Path.isDir(path_string);
    }
    
    open var basename: String {
        return (path_string as NSString).lastPathComponent
    }
    
    open var parent: Path{
        return Path((path_string as NSString).deletingLastPathComponent)
    }
    
    // MARK: - Instance methods
    
    open func toString() -> String {
        return path_string
    }
    
    @discardableResult
    open func remove() -> PathResult<Path, NSError> {
        assert(self.exists,"To remove file, file MUST be exists")

        do {
            try fileManager.removeItem(atPath: path_string)
            return PathResult(success: self)
        } catch let error as NSError {
            return PathResult(failure: error)
        }

    }
    
    @discardableResult
    open func copyTo(_ toPath:Path) -> PathResult<Path, NSError> {
        assert(self.exists,"To copy file, file MUST be exists")

        do {
            try fileManager.copyItem(atPath: path_string,
                        toPath: toPath.toString())
            return PathResult(success: self)
        } catch let error as NSError {
            return PathResult(failure: error)
        }

    }
    
    @discardableResult
    open func moveTo(_ toPath:Path) -> PathResult<Path, NSError> {
        assert(self.exists,"To move file, file MUST be exists")

        do {
            try fileManager.moveItem(atPath: path_string,
                        toPath: toPath.toString())
            return PathResult(success: self)
        } catch let error as NSError {
            return PathResult(failure: error)
        }

    }
    
    fileprivate func loadAttributes() -> [FileAttributeKey : Any] {
        assert(self.exists,"File must be exists to load file.< \(path_string) >")

        do {
            let result = try self.fileManager.attributesOfItem(atPath: path_string)
            return result
        } catch let error as NSError {
            print("Error< \(error.localizedDescription) >")
            return [:]
        }

    }
    
}

// MARK: -

extension Path:  CustomStringConvertible {
    public var description: String {
        return "\(NSStringFromClass(type(of: self)))<path:\(path_string)>"
    }
}


