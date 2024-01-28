//
//  File.swift
//  
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Foundation
import Domain

public class Repo: AddRepo, DeleteRepo, FavoriteRepo, ReadRepo {
    var set = NSMutableOrderedSet()
    var array = Array<WordInfoEntity>()

    public init() {}

    public func read(startIndex: IndexType, pageMaxSize: Int, _ handler: @escaping (Result<[WordEntity], Error>) -> Void) {
        guard startIndex < set.count else {
            handler(.failure(ErrorEntity.error))
            return
        }
        let endIndex = min(startIndex - 1 + pageMaxSize, set.count - 1)
        var result = Array<WordEntity>()
        for i in startIndex...endIndex {
            result.append(.init(word: set[i] as! String, info: array[i]))
        }
        handler(.success(result))
    }

    public func add(word: String, _ handler: @escaping (Result<Int?, Error>) -> Void) {
        // write to the end of the file

        let index = set.index(of: word)

        if index == NSNotFound {
            set.add(word)
            array.append(.init(favorite: false, count: 1))
            handler(.success(array.count - 1))
        } else {
            array[index].count += 1
            handler(.success(nil))
        }
    }

    public func delete(word: String, _ handler: @escaping (Result<Int?, Error>) -> Void) {
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

    public func favorite(word: String, _ handler: @escaping (Result<Int?, Error>) -> Void) {
        update(word: word, favorite: true, handler)
    }

    public func unfavorite(word: String, _ handler: @escaping (Result<Int?, Error>) -> Void) {
        update(word: word, favorite: false, handler)
    }

    private func update(word: String, favorite: Bool, _ handler: @escaping (Result<Int?, Error>) -> Void) {
        let index = set.index(of: word)
        guard index != NSNotFound else { return }
        array[index].favorite = favorite
        handler(.success(index))
    }
}
