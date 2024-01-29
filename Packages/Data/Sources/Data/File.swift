//
//  File.swift
//  
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Foundation
import Domain

public class Repo: AddRepo, DeleteRepo, FavoriteRepo, ReadRepo, InfoRepo {
    var set = NSMutableOrderedSet()
    var array = Array<WordInfoEntity>()

    public init() {
        if let path = Bundle.main.path(forResource: "words", ofType: "txt") {
            do {
                let str = try String(contentsOfFile: path, encoding: .utf8)
                let res = str.split(separator: "\n")
                res.forEach {
                    let s = String($0)
                    if set.contains(s) {
                        let i = set.index(of: s)
                        array[i].count += 1
                    } else {
                        set.add(s)
                        array.append(.init(favorite: false, count: 1))
                    }
                }
            } catch let error {
                print(error)
                print("")
            }
        }
    }

    public func info(of word: WordType, _ handler: @escaping (Result<WordInfoEntity, Error>) -> Void) {
        let index = set.index(of: word)

        if index == NSNotFound {
            handler(.failure(ErrorEntity.error))
        } else {
            array[index].count += 1
            handler(.success(array[index]))
        }
    }

    public func read(startIndex: IndexType, pageMaxSize: Int, _ handler: @escaping (Result<[WordType], Error>) -> Void) {
        guard startIndex < set.count else {
            handler(.success([]))
            return
        }
        let endIndex = min(startIndex - 1 + pageMaxSize, set.count - 1)
        var result = Array<WordType>()
        for i in startIndex...endIndex {
            result.append(set[i] as! WordType)
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
