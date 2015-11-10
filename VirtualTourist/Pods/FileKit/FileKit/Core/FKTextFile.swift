//
//  FKTextFile.swift
//  FileKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// A representation of a filesystem text file.
///
/// The data type is `String`.
///
public class FKTextFile: FKFile<String> {
    
    /// The text file's string encoding.
    public var encoding: NSStringEncoding = NSUTF8StringEncoding
    
    /// Initializes a text file from a path.
    public required init(path: FKPath) {
        super.init(path: path)
    }
    
    /// Reads a string from the text file's path.
    public override func read() throws -> String {
        do {
            return try String(contentsOfFile: path.rawValue)
        } catch {
            throw FKError.ReadFromFileFail(path: path)
        }
    }
    
    /// Writes a string to a text file using the file's encoding.
    ///
    /// Writing is done atomically by default.
    ///
    /// - Parameter data: The string to be written to the text file.
    ///
    /// - Throws: `FKError.WriteToFileFail`
    ///
    public override func write(data: String) throws {
        try write(data, atomically: true)
    }
    
    /// Writes a string to a text file using the file's encoding.
    ///
    /// - Parameter data: The string to be written to the text file.
    ///
    /// - Parameter atomically: If `true`, the string is written to an auxiliary
    ///                         file that is then renamed to the file. If
    ///                         `false`, the string is written to the text file
    ///                         directly.
    ///
    /// - Throws: `FKError.WriteToFileFail`
    ///
    public func write(data: String, atomically useAuxiliaryFile: Bool) throws {
        do {
            try data.writeToFile(path.rawValue, atomically: useAuxiliaryFile, encoding: encoding)
        } catch {
            throw FKError.WriteToFileFail(path: path)
        }
    }
    
}


