//
//  Differentor.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation
import DifferenceKit

public struct Differentor<T: Differentiable> {
    public struct Changeset {
        public let inserted: [T]
        public let deleted: [T]
        public let updated: [T]
    }

    public let source: [T]

    public let target: [T]

    public func diff() -> Changeset {
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
