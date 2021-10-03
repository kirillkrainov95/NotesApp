//
//  Model.swift
//  NotesApp
//
//  Created by Kirill Kraynov on 10/1/21.
//

import Foundation
import UIKit
import RealmSwift

    // Модель сделана для методов при работе с БД и контроллерами
class Model {
    
    //MARK: - Переменные и константы
    
    let realm = try? Realm()
    
    // парсит таблицу из БД и является основным массивом при работе с данными
    var testNotes: Results<Item>? {
        return realm?.objects(Item.self)
    }
    // вспомогательный массив
    var helper: Results<Item>?

    
    // MARK: - Вспомогательная переменная для сортировки
    var sortAscending: Bool = true
    
    // MARK: - Методы
    

    
    // MARK: - Добавить заметку
    func addNewNote (
                     titleString: String,
                     bodyString: String) {
        let newObject = Item()
        newObject.id = (testNotes?.count ?? 0)
        newObject.title = titleString
        newObject.fullText = bodyString
        
        try? realm?.write {
            realm?.add(newObject)
        }
    }
    
    // MARK: - Редактировать заметку
    func updateNote(at index: Int,
                       titleString: String,
                       bodyString: String) {
        do {
            try realm?.write {
                testNotes?[index].title = titleString
                testNotes?[index].fullText = bodyString
            }
        } catch {
            print("\(error)")
        }
    }
    
   
    
    // MARK: - Удалить заметку
    func deleteNote(at index: Int) {
        if let note = testNotes?[index] {
            do {
                try realm?.write {
                    realm?.delete(note)
                }
            } catch {
                print("\(error)")
            }
        }
    }
    
    // MARK: - Поиск
    func search(searchTextValue: String) {
        
        let predicates = ["title", "fullText"].map { property in
          NSPredicate(format: "%K CONTAINS [c]%@", property, searchTextValue)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        helper = testNotes?.filter(predicate)

    }
    
    func sortWithTitle() {
        helper = testNotes?.sorted(byKeyPath: "title", ascending: sortAscending)
    }
    
    // MARK: - Создаём нулевую заметку
    
    func zeroNoteCreation() {
        let zeroNoteObject = Item()
        
        if testNotes?.isEmpty == true {
            do {
                try? realm?.write {
                    realm?.add(zeroNoteObject)
            }
            } catch let error as NSError {
                print(error)
            }
        }
    }

}

