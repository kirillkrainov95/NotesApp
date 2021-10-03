//
//  Item.swift
//  NotesApp
//
//  Created by Kirill Kraynov on 10/1/21.
//

import Foundation
import RealmSwift

// MARK: - Модель объекта для Realm

class Item: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String? = "Тест"
    @objc dynamic var fullText: String? = "Полный текст заметки"
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
