//
//  CloudKitCodable.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/2.
//

import Foundation
import CloudKitCodable

extension CodeSnippet: CloudKitCodable {
    var cloudKitIdentifier: CloudKitIdentifier { identifier }

    static func resolveConflict(clientModel: CodeSnippet, serverModel: CodeSnippet) -> CodeSnippet? {
//        if clientModel == serverModel {
//            return nil
//        }

        let clientDate = clientModel.modifiedDate

        if let serverDate = serverModel.cloudKitLastModifiedDate {
            return clientDate > serverDate ? clientModel : serverModel
        }

        return clientModel
    }
}
