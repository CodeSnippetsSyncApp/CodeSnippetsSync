//
//  Differentor.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation
import DifferenceKit

struct Differentor<T: Differentiable> {
    struct Changeset {
        let inserted: [T]
        let deleted: [T]
        let updated: [T]
    }

    let source: [T]

    let target: [T]

    func diff() -> Changeset {
        let changeset = StagedChangeset(source: source, target: target)
        var inserted: [T] = []
        var deleted: [T] = []
        var updated: [T] = []
        for change in changeset {
            inserted.append(contentsOf: change.elementInserted.map { target[$0.element] })
            deleted.append(contentsOf: change.elementDeleted.map { source[$0.element] })
            updated.append(contentsOf: change.elementUpdated.map { change.data[$0.element] })
        }
        return Changeset(inserted: inserted, deleted: deleted, updated: updated)
    }
}
