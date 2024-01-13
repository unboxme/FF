//
//  Created on 13/01/2024
//  Copyright © Pavel Puzyrev. All rights reserved.
//

struct OnDemandResourceMetadata {
    let tag: String
    let name: String
    let `extension`: String
}

extension OnDemandResourceMetadata {
    static let fastForex = OnDemandResourceMetadata(tag: "APIKeys", name: "APIKeys", extension: "json")
}
