//
//  DefaultRepo.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Foundation
import Domain

public class DefaultRepo {
    let bundle: Bundle
    let fileManager: FileManager
    var keys = NSMutableOrderedSet()
    var values = Array<WordInfoEntity>()

    public init(bundle: Bundle = .main, fileManager: FileManager = .default) {
        self.bundle = bundle
        self.fileManager = fileManager
    }
}
