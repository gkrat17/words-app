//
//  File.swift
//  
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Foundation

class Repo {
    var set = NSMutableOrderedSet()
    var array = Array<Info>()

    func fetch(lastIndex: Int, page: UInt, handler: @escaping (Result<Void, Error>) -> Void) {
        
    }
    func add(word: String, handler: @escaping (Result<Int?, Error>) -> Void) {
        // write to the end of the file

        let index = set.index(of: word)

        if index == NSNotFound {
            set.add(word)
            array.append(.init(count: 1, favorite: false))
            handler(.success(array.count - 1))
        } else {
            array[index].count += 1
            handler(.success(nil))
        }
    }

    func delete(word: String, handler: @escaping (Result<Int?, Error>) -> Void) {
        // delete last occurence of the word in a file

        let index = set.index(of: word)

        guard index != NSNotFound,
              array[index].count > .zero
        else {
            // handler(.failure(ErrorEntity.error))
            return
        }

        array[index].count -= 1

        if array[index].count == .zero {
            set.remove(word)
            array.remove(at: index) // insufficient part :(
            handler(.success(index))
        } else {
            handler(.success(nil))
        }
    }

    func favorite(word: String) {
        update(word: word, favorite: true)
    }

    func unfavorite(word: String) {
        update(word: word, favorite: false)
    }

    private func update(word: String, favorite: Bool) {
        let index = set.index(of: word)
        guard index != NSNotFound else { return }
        array[index].favorite = favorite
    }
}

class Info {
    var count: UInt
    var favorite: Bool

    init(count: UInt, favorite: Bool) {
        self.count = count
        self.favorite = favorite
    }
}


