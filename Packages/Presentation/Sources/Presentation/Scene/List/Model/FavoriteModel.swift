//
//  FavoriteModel.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain

class FavoriteModel: Hashable {
    let word: WordType
    let index: IndexType

    init(word: WordType, index: IndexType) {
        self.word = word
        self.index = index
    }

    static func == (lhs: FavoriteModel, rhs: FavoriteModel) -> Bool {
        lhs.word == rhs.word /* && lhs.index == rhs.index*/
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
        // hasher.combine(index)
    }
}
