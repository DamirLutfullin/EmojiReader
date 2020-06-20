//
//  ViewController.swift
//  EmojiReader
//
//  Created by Damir Lutfullin on 17.06.2020.
//  Copyright © 2020 DamirLutfullin. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var arrayOfEmoji: [EmojiData] = [
        EmojiData(emoji: "😀", name: "Smile", comment: "Cool emoji", isFavotite: true),
        EmojiData(emoji: "🥰", name: "Love", comment: "Cool emoji", isFavotite: true),
        EmojiData(emoji: "😘", name: "Kiss", comment: "Cool emoji", isFavotite: true),
        EmojiData(emoji: "🤪", name: "Crazy", comment: "Cool emoji", isFavotite: true),
        EmojiData(emoji: "😜", name: "Hot", comment: "Cool emoji", isFavotite: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EmojiTableViewCell.self, forCellReuseIdentifier: "cell")
        title = "Emoji reader"
        self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(go))
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.separatorStyle = .singleLine
    }
    
    @objc func go() {
        let detailVC = NavControllerForNewEmojiTableVC(rootViewController: NewEmojiTableVC(style: .grouped))
        let newEmojiTVC = detailVC.viewControllers.first as! NewEmojiTableVC
        newEmojiTVC.deleagate = self
        self.navigationController?.show(detailVC, sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = NavControllerForNewEmojiTableVC(rootViewController: NewEmojiTableVC(style: .grouped))
        let newEmojiTVC = detailVC.viewControllers.first as! NewEmojiTableVC
        newEmojiTVC.commentText = arrayOfEmoji[indexPath.row].comment
        newEmojiTVC.emojiText = arrayOfEmoji[indexPath.row].emoji
        newEmojiTVC.nameText = arrayOfEmoji[indexPath.row].name
        newEmojiTVC.numberOfRow = indexPath.row
        newEmojiTVC.deleagate = self
        self.navigationController?.show(detailVC, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfEmoji.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmojiTableViewCell
        cell.set(emoji: arrayOfEmoji[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayOfEmoji.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
        let emoji = arrayOfEmoji.remove(at: sourceIndexPath.row)
        arrayOfEmoji.insert(emoji, at: destinationIndexPath.row)
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let isFavoriteButton = isFavoriteAction(atIndexPath: indexPath)
        let doneButt = doneButton(atIndexPath: indexPath)
        
        let configuration = UISwipeActionsConfiguration(actions: [isFavoriteButton, doneButt ])
        
        return configuration
    }
    
    func isFavoriteAction(atIndexPath indexPath: IndexPath) -> UIContextualAction {
        let isFavoriteButton = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            self.arrayOfEmoji[indexPath.row].isFavotite.toggle()
            completion(true)
        }
        isFavoriteButton.backgroundColor = self.arrayOfEmoji[indexPath.row].isFavotite ? .systemPurple : .systemGray
        isFavoriteButton.image = UIImage.init(systemName: "heart")
        return isFavoriteButton
    }
    
    func doneButton(atIndexPath indexPath: IndexPath) -> UIContextualAction {
        let doneButton = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            self.arrayOfEmoji.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        doneButton.backgroundColor = .systemGreen
        doneButton.image = UIImage.init(systemName: "checkmark.circle")
        return doneButton
    }
    
}

//MARK: Back emoji protocol
extension MainTableViewController: backEmoji {
    
    func getEmoji(emoji: EmojiData, numberOfRow: Int?) {
        if let numberOfRow = numberOfRow {
            self.arrayOfEmoji[numberOfRow] = emoji
            tableView.reloadRows(at: [IndexPath(row: numberOfRow, section: 0)], with: .automatic)
        } else {
            self.arrayOfEmoji.append(emoji)
            tableView.insertRows(at: [IndexPath(row: arrayOfEmoji.count - 1, section: 0)], with: .automatic)
        }
    }
    
}
