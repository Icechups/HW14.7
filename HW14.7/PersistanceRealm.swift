//
//  PersistanceRealm.swift
//  HW14.7
//
//  Created by Илья Перевозкин on 23.12.2022.
//

import Foundation
import RealmSwift

class PersistanceRealm: Object {
    @Persisted var task = ""
}
class NetworkObject: Object {
    @Persisted var nameCharacter = ""
    @Persisted var status = ""
    @Persisted var species = ""
    @Persisted var location = ""
    @Persisted var image = ""
}
