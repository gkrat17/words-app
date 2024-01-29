////
////  ResourceManager.swift
////
////  Created by giorgi kratsashvili on 29.01.24.
////
//
//import Foundation
//
//final class ResourceManager {
//    func load() {
//        guard let path = bundle.path(forResource: "words", ofType: "txt")
//        else { fatalError("can't find words.txt file") }
//
//        let string: String
//        do {
//            string = try String(contentsOfFile: path, encoding: .utf8)
//        } catch let error {
//            fatalError("error occurred while parsing file: \(error.localizedDescription)")
//        }
//
//        let splitted = string.split(separator: "\n")
//
//        splitted.forEach {
//            let string = String($0)
//            if keys.contains(string) {
//                let i = keys.index(of: string)
//                values[i].count += 1
//            } else {
//                keys.add(string)
//                values.append(.init(favorite: false, count: 1))
//            }
//        }
//    }
//    func append(string: String) {
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return // fatalError("Unable to access documents directory.")
//        }
//
//        let fileURL = documentsDirectory.appendingPathComponent("words.txt")
//
//        if FileManager.default.fileExists(atPath: fileURL.path) {
//            do {
//                let fileHandle = try FileHandle(forWritingTo: fileURL)
//                fileHandle.seekToEndOfFile()
//
//                if let data = string.data(using: .utf8) {
//                    fileHandle.write(data)
//                }
//
//                fileHandle.closeFile()
//            } catch {
//                print("Error writing to file: \(error)")
//            }
//        } else {
//            do {
//                try string.write(to: fileURL, atomically: true, encoding: .utf8)
//            } catch {
//                print("Error creating file: \(error)")
//            }
//        }
//    }
//
//    func deleteLast(string: String) {
//        
//    }
//}
//
//func appendTextToFileInDocuments(_ text: String, fileName: String) {
//    // Save data to file
//    let fileName = "words"
//    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//    
//    let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
//    print("FilePath: \(fileURL.path)")
//    
//    let writeString = "Write this text to the fileURL as text in iOS using Swift"
//    do {
//        // Write to the file
//        try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
//    } catch let error as NSError {
//        print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
//    }
//    
//    var readString = "" // Used to store the file contents
//    do {
//        // Read the file contents
//        readString = try String(contentsOf: fileURL)
//    } catch let error as NSError {
//        print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
//    }
//    print("File Text: \(readString)")
//    
//}
