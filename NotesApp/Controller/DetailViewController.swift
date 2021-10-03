//
//  DetailViewController.swift
//  NotesApp
//
//  Created by Kirill Kraynov on 10/1/21.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    var alert = UIAlertController()
    
    @IBOutlet weak var noteTitleLabel: UILabel!
    
    @IBOutlet weak var noteBodyTextView: UITextView!
    
    let model = Model()
    var receivedIndex: Int = Int()
    var localIndexPath: IndexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        noteBodyTextView.isEditable = false
        noteBodyTextView.layer.borderWidth = 0.5
        noteBodyTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    func loadData(){
        noteTitleLabel.text = model.testNotes?[receivedIndex].title
        noteBodyTextView.text = model.testNotes?[receivedIndex].fullText
 
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showEditingScreen" {
            guard let destViewController = segue.destination as? EditingModeViewController else {
                return
            }
            destViewController.operationName = "Редактировать заметку"
            destViewController.sharedIndex = receivedIndex
            destViewController.editingModeIsOn = true
        }
    }

    // MARK: - Экшены
    
    @IBAction func unwindToCurrentController(segue: UIStoryboardSegue) {
        loadData()
    }
    
    @IBAction func editingButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        confirmNoteDeleting(at: receivedIndex)
    }
    
    // MARK: - Алерт
    func confirmNoteDeleting(at index: Int) {
        
        if let noteName = noteTitleLabel.text {
            alert = UIAlertController(title: "Заметка '\(noteName)' будет удалена. Вы уверены?", message: nil, preferredStyle: .alert)
        }
        
        let cancelAlertAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        
        let confirmAlertAction = UIAlertAction(title: "Да", style: .default) { (createAlert) in
            self.model.deleteNote(at: self.receivedIndex)
            self.performSegue(withIdentifier: "unwindBackToMainList", sender: self)

        }
        alert.addAction(cancelAlertAction)
        alert.addAction(confirmAlertAction)
        present(alert, animated: true, completion: nil)
        
    }
    

}
