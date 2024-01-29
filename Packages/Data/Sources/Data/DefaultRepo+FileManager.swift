//
//  DefaultRepo+FileManager.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Foundation

extension DefaultRepo {
    public func load() throws {
        let url = url

        if fileManager.fileExists(atPath: url.path) {
            let string = try String(contentsOf: url, encoding: .utf8)
            process(string: string)
            return
        }

        guard let path = bundle.path(forResource: fileName, ofType: fileExtension)
        else { fatalError("can't find file") }

        let string = try String(contentsOfFile: path, encoding: .utf8)
        try string.write(to: url, atomically: true, encoding: .utf8)
        process(string: string)
    }

    func append(string: String) throws {
        let handle = try FileHandle(forWritingTo: url)
        handle.seekToEndOfFile()
        guard let data = "\(string)\n".data(using: .utf8) else { return }
        handle.write(data)
        handle.closeFile()
    }

    func deleteLast(string: String) throws {
        let url = url
        var content = try String(contentsOf: url, encoding: .utf8)
        let string = "\(string)\n"
        guard let range = content.range(of: string, options: .backwards) else { return }
        content.replaceSubrange(range, with: "")
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
}

fileprivate extension DefaultRepo {
    var fileName: String { "words" }
    var fileExtension: String { "txt" }
    var fullFileName: String { "\(fileName).\(fileExtension)" }

    var url: URL {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("unable to access documents directory.")
        }
        return documentsDirectory.appendingPathComponent(fullFileName)
    }

    func process(string: String) {
        let string = string.split(separator: "\n")
        string.forEach {
            let string = String($0)
            if keys.contains(string) {
                let i = keys.index(of: string)
                values[i].count += 1
            } else {
                keys.add(string)
                values.append(.init(favorite: false, count: 1))
            }
        }
    }
}
