//
//  PersistanceUserDefoults.swift
//  HW14.7
//
//  Created by Илья Перевозкин on 22.12.2022.
//

import Foundation

class PersistanceUserDefaults {
    static let shared = PersistanceUserDefaults()
    
    private let kUserNameKey = "PersistanceUserDefaults.kUserNameKey"
    private let kUserSecondName = "PersistanceUserDefaults.kUserSecondName"
    
    var userName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserNameKey) }
        get { return UserDefaults.standard.string(forKey: kUserNameKey) }
    }
    var secondUserName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserSecondName) }
        get { return UserDefaults.standard.string(forKey: kUserSecondName) }
    }
}
