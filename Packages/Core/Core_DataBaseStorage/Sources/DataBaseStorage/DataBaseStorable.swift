//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import RealmSwift

public protocol DataBaseStorable {
    associatedtype DataBaseModel: Object

    func makeDataBaseModel() -> DataBaseModel
    static func make(from dataBaseModel: DataBaseModel) -> Self
}
