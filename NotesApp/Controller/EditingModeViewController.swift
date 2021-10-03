//
//  AddNoteViewController.swift
//  NotesApp
//
//  Created by Kirill Kraynov on 10/1/21.
//

import UIKit
import RealmSwift

class EditingModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editingBodyTextView.layer.borderWidth = 0.5
        editingBodyTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        operationNameLabel.text = operationName
        
        if editingModeIsOn == true {
            editingTitleField.text = model.testNotes?[sharedIndex].title
            editingBodyTextView.text = model.testNotes?[sharedIndex].fullText
            
        } else if editingModeIsOn == false {
            editingTitleField.text = ""
            editingBodyTextView.text = ""
        }

    }
    
    // MARK: - Аутлеты
    @IBOutlet weak var operationNameLabel: UILabel!
    
    @IBOutlet weak var editingTitleField: UITextField!
    
    @IBOutlet weak var editingBodyTextView: UITextView!
    
    // MARK: - Локальные переменные и константы
    var operationName: String = ""
    var sharedIndex: Int = Int()
    var idHelper: Int = Int()
    var editingModeIsOn: Bool = false
    let model = Model()
    
    
    // Завершаем и сохраняем
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        // MARK: - ВАЖНО!
        if editingModeIsOn == false {
            model.addNewNote(titleString: editingTitleField.text ?? "", bodyString: editingBodyTextView.text ?? "")
            
            performSegue(withIdentifier: "unwindBackWithSegue", sender: self)
        }
        
        if editingModeIsOn == true {
            model.updateNote(at: sharedIndex,
                                titleString: editingTitleField.text ?? "",
                                bodyString: editingBodyTextView.text ?? "")
    
        performSegue(withIdentifier: "unwindBackWithSegue", sender: self)
        }
    }
    // Выходим с экрана через отмену
    @IBAction func cancelButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindBackWithSegue", sender: self)
    }

}
