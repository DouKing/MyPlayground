//===----------------------------------------------------------*- Swift -*-===//
//
// Created by wuyikai on 2024/5/23.
// Copyright © 2024 wuyikai. All rights reserved.
//
//===----------------------------------------------------------------------===//

import Foundation
import AudioToolbox

public class AudioFile {
    private let fileID: AudioFileID
    public  let filePath: String
    private let valid: Bool
    public  let nextPacket: Int64
    
    deinit {
        self.dispose()
    }
    
    init(fileID: AudioFileID, filePath: String) {
        self.fileID = fileID
        self.filePath = filePath
        self.valid = true
        self.nextPacket = 0
    }
    
    public static func open(path: String) throws -> AudioFile {
        guard let inputFileURL = CFURLCreateFromFileSystemRepresentation(
            kCFAllocatorDefault, path,
            path.count, false)
        else {
            throw AudioToolboxError.invalidPath
        }
        
        var fileId: AudioFileID?
        let status = AudioFileOpenURL(inputFileURL, .readPermission, .init(0), &fileId)
        
        guard status == noErr, let fileId else {
            throw AudioToolboxError.runtime(status, "Unable to open the input file '\(path)'")
        }
        
        return AudioFile(fileID: fileId, filePath: path)
    }
    
    public static func create(
        path: String,
        fileType: AudioFileTypeID,
        format: AudioStreamBasicDescription
    ) throws -> AudioFile {
        guard let outputFileURL = CFURLCreateFromFileSystemRepresentation(
            kCFAllocatorDefault, path,
            path.count, false)
        else {
            throw AudioToolboxError.invalidPath
        }
        
        var fileId: AudioFileID?
        var format = format
        let status = AudioFileCreateWithURL(outputFileURL, fileType, &format, .eraseFile, &fileId)
        
        guard status == noErr, let fileId else {
            throw AudioToolboxError.runtime(status, "Unable to create the output file '\(path)'")
        }
        
        return AudioFile(fileID: fileId, filePath: path)
    }
    
    private func dispose() {
        if valid {
            AudioFileClose(self.fileID)
        }
    }
}
