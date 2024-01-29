//
//  ReplaceModel.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain

class ReplaceModel {
    let section: SectionType
    let item: WordType
    let neighbor: NeighborType?

    init(section: SectionType, item: WordType, neighbor: NeighborType?) {
        self.section = section
        self.item = item
        self.neighbor = neighbor
    }
}

extension ReplaceModel {
    enum NeighborType {
        case before(WordType)
        case after(WordType)
    }
}
