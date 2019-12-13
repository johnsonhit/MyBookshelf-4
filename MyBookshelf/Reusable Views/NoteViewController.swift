//
//  NoteViewController.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 13/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate {
    func noteCreated(note: String)
}

class NoteViewController: UIViewController {
    
    static let storyboardIdentifier = "NoteViewController"
    
    var delegate: NoteViewControllerDelegate?
    
    @IBOutlet weak var textView: UITextView!
    
    var isbn13: String?

    override func viewDidLoad() {
        guard let isbn13 = isbn13 else { return }
        super.viewDidLoad()
        
        if let userNoteExists = RealmClient.shared.retrieveUserNote(isbn13: isbn13) {
            self.textView.text = userNoteExists.note
        }
        
    }
    
    @IBAction func cancleButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let text = self.textView.text else {
            return
        }
        
        self.dismiss(animated: true) {
            self.delegate?.noteCreated(note: text)
        }
    }
    
}
