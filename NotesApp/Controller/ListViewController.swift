//
//  ViewController.swift
//  NotesApp
//
//  Created by Kirill Kraynov on 10/1/21.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - UITableViewDelegate & UITableViewDataSource методы
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.helper?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = mainListTableView.dequeueReusableCell(withIdentifier: "NotePreviewCell", for: indexPath) as? NoteTableViewCell,
              let item = model.helper?[indexPath.row] else {
              
            return UITableViewCell()
        }
        
        cell.data = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let destViewController = storyboard?.instantiateViewController(withIdentifier: "StDetailViewController") as? DetailViewController else {
            return
        }
        // передаём id из массива заметок
        destViewController.receivedIndex = model.helper?[indexPath.row].id ?? 0
        navigationController?.pushViewController(destViewController, animated: true)
        mainListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Поиск
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.search(searchTextValue: searchText)
        
        if searchBar.text?.count == 0 {
            model.helper = model.testNotes
        }
        
        DispatchQueue.main.async {
            self.mainListTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.helper = model.testNotes
        if searchBar.text?.count == 0 {
            model.helper = model.testNotes
        }
        model.sortWithTitle()
        DispatchQueue.main.async {
            self.mainListTableView.reloadData()
        }
    }
    
    // MARK: - Переменные
    var model = Model()
    var localIndexPath: IndexPath = IndexPath()
    var searchController = UISearchController()

    // MARK: - Аутлеты и экшены
    
    @IBOutlet weak var mainListTableView: UITableView!
    

    @IBOutlet weak var sortingButton: UIBarButtonItem!
    
    @IBAction func sortingButtonPressed(_ sender: UIBarButtonItem) {
        let arrowUp = UIImage(systemName: "arrow.up")
        let arrowDown = UIImage(systemName: "arrow.down")
        
        model.sortAscending = !model.sortAscending
        sortingButton.image = model.sortAscending ? arrowUp : arrowDown
        
        model.sortWithTitle()
        
        DispatchQueue.main.async {
            self.mainListTableView.reloadData()
        }
    }
    

    @IBAction func addNoteButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func unwindToCurrentController(segue: UIStoryboardSegue) {
        DispatchQueue.main.async {
            self.mainListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        model.helper = model.testNotes
 
        mainListTableView.delegate = self
        mainListTableView.dataSource = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Найдите заметку по словам из неё"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let xibCell = UINib(nibName: "NoteTableViewCell", bundle: nil)
        
        mainListTableView.register(xibCell, forCellReuseIdentifier: "NotePreviewCell")
        
        model.zeroNoteCreation()
        
        model.sortWithTitle()
        DispatchQueue.main.async {
            self.mainListTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model.sortWithTitle()
        DispatchQueue.main.async {
            self.mainListTableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showAddingScreen" {
            
            guard let destViewController = segue.destination as? EditingModeViewController else {
                return
            }
            
            destViewController.operationName = "Добавить заметку"
        }

    }
}

