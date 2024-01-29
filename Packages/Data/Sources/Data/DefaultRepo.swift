//
//  DefaultRepo.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Foundation
import Domain

public class DefaultRepo {
    let bundle: Bundle
    var keys = NSMutableOrderedSet()
    var values = Array<WordInfoEntity>()

    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    public func load() {
        guard let path = Bundle.main.path(forResource: "words", ofType: "txt")
        else { fatalError("can't find words.txt file") }

        let string: String
        do {
            string = try String(contentsOfFile: path, encoding: .utf8)
        } catch let error {
            fatalError("error occurred while parsing file: \(error.localizedDescription)")
        }

        let splitted = string.split(separator: "\n")

        splitted.forEach {
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
