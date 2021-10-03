//
//  NoteTableViewCell.swift
//  NotesApp
//
//  Created by Kirill Kraynov on 10/1/21.
//

import UIKit
import RealmSwift

// MARK: - Кастомная ячейка списка

class NoteTableViewCell: UITableViewCell {
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let model = Model()
    
    var data: Item? {
        didSet {
            guard let unwrData = data else {
                return
            }
            titleLabel.text = unwrData.title ?? "(без заголовка)"
            descriptionLabel.text = unwrData.fullText ?? "(без текста)"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
