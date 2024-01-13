//
//  Created on 22/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation

extension [CodingKey] {
    func description() -> String {
        let description = self
            .enumerated()
            .map { "\($0.offset == self.count - 1 ? ">" : "-") \($0.element.stringValue)" }
            .joined(separator: "\n")

        if description.isEmpty {
            return "-"
        } else {
            return description
        }
    }
}
