//
//  InsertModel.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain

class InsertModel {
    enum Neighbor {
        case before(WordType)
        case after(WordType)

        var word: WordType {
            switch self {
            case .before(let wordType): wordType
            case .after(let wordType):  wordType
            }
        }
    }

    let item: WordType
    let neighbor: Neighbor?

    init(item: WordType, neighbor: Neighbor?) {
        self.item = item
        self.neighbor = neighbor
    }
}
