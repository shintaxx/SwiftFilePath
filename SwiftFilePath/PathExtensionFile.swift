//
//  File.swift
//  SwiftFilePath
//
//  Created by nori0620 on 2015/01/08.
//  Copyright (c) 2015年 Norihiro Sakamoto. All rights reserved.
//

// Add File Behavior to Path by extension
extension  Path {
    
    public var ext: String {
        return (path_string as NSString).pathExtension
    }
    
    public func touch() -> PathResult<Path, NSError> {
        assert(!self.isDir,"Can NOT touch to dir")
        return self.exists
            ? self.updateModificationDate()
            : self.createEmptyFile()
    }
    
    public func updateModificationDate(_ date: Date = Date()) -> PathResult<Path, NSError> {

        do {
            try fileManager.setAttributes(
                        [FileAttributeKey.modificationDate :date],
                        ofItemAtPath:path_string)
            return PathResult(success: self)
        } catch let error as NSError {
            return PathResult(failure: error)
        }

    }
    
    fileprivate func createEmptyFile() -> PathResult<Path, NSError> {
        return self.writeString("")
    }
    
    // MARK: - read/write String
    
    public func readString() -> String? {
        assert(!self.isDir,"Can NOT read data from  dir")

        do {
            let read = try String(contentsOfFile: path_string,
                                            encoding: String.Encoding.utf8)
            return read
        } catch let error as NSError {
            print("readError< \(error.localizedDescription) >")
            return nil
        }
        
    }
    
    public func writeString(_ string:String) -> PathResult<Path, NSError> {
        assert(!self.isDir,"Can NOT write data from  dir")

        do {
            try string.write(toFile: path_string,
                        atomically:true,
                        encoding: String.Encoding.utf8)
            return PathResult(success: self)
        } catch let error as NSError {
            return PathResult(failure: error)
        }
    }
    
    // MARK: - read/write NSData
    
    public func readData() -> Data? {
        assert(!self.isDir,"Can NOT read data from  dir")
        return (try? Data(contentsOf: URL(fileURLWithPath: path_string)))
    }
    
    public func writeData(_ data:Data) -> PathResult<Path, NSError> {
        assert(!self.isDir,"Can NOT write data from  dir")

        do {
            try data.write(to: URL(fileURLWithPath: path_string), options:.atomic)
            return PathResult(success: self)
        } catch let error as NSError {
            return PathResult(failure: error)
        }
    }
    
}
