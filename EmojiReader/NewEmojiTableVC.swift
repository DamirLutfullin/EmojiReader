//
//  DetailTableViewController.swift
//  EmojiReader
//
//  Created by Damir Lutfullin on 18.06.2020.
//  Copyright © 2020 DamirLutfullin. All rights reserved.
//

import UIKit

protocol backEmoji: class {
    func getEmoji(emoji: EmojiData)
}

class NavControllerForNewEmojiTableVC: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewEmojiTableVC: UITableViewController {
    
    weak var deleagate: backEmoji?
    
    var emojiCell = UITableViewCell()
    var nameCell = UITableViewCell()
    var commentCell = UITableViewCell()
    
    var emojiTF: UITextField!
    var nameTF: UITextField!
    var commentTF: UITextField!
    
    var emojiText: String?
    var nameText: String?
    var commentText: String?
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        createInterface()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiTF.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        nameTF.addTarget(self, action: #selector(textFieldDidChange(_:)),
                         for: .editingChanged)
        commentTF.addTarget(self, action: #selector(textFieldDidChange(_:)),
                            for: .editingChanged)
        
        if emojiText != nil, nameText != nil, commentText != nil {
            emojiTF.text = emojiText
            nameTF.text = nameText
            commentTF.text = commentText
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return emojiCell
        case 1:
            return nameCell
        case 2:
            return commentCell
        default:
            fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "EMOJI"
        case 1:
            return "NAME"
        case 2:
            return "COMMENT"
        default:
            fatalError("not section for name")
        }
    }
    
    private func createInterface() {
        //set button
        self.navigationItem.rightBarButtonItem = .init(title: "save", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem = .init(title: "cancel", style: .plain, target: self, action: #selector(cancel))
        
        emojiTF = UITextField(frame: self.emojiCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        emojiCell.contentView.addSubview(emojiTF)
        
        nameTF = UITextField(frame: self.nameCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        nameCell.contentView.addSubview(nameTF)
        
        commentTF = UITextField(frame: self.commentCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        commentCell.contentView.addSubview(commentTF)
    }
    
    @objc private func save() {
        self.dismiss(animated: true) {
            self.deleagate?.getEmoji(emoji: EmojiData(emoji: self.emojiTF.text!, name: self.nameTF.text!, comment: self.commentTF.text!, isFavotite: false))
        }
       
    }
    
    @objc private func cancel() {
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let emojiText = emojiTF.text ?? ""
        let nameText = nameTF.text ?? ""
        let descriptionText = commentTF.text ?? ""
        navigationItem.rightBarButtonItem?.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty
    }
    
}

