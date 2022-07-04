//
//  ViewController.swift
//  Project5_WordScramble
//
//  Created by Ilia Abrosimov on 04.07.2022.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
                                                            
        if let urlStart = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWord = try? String (contentsOf: urlStart) {
                 allWords = startWord.components(separatedBy: "\n")
            }
            if allWords.isEmpty {
                allWords = ["silkWorm"]
            }
        }
      startGame()
        
        // Do any additional setup after loading the view.
    }
     @objc func promptForAnswer() {
         let ac = UIAlertController(title: "Prompts the word", message: ""  , preferredStyle:.alert)
         ac.addTextField()
         let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
             guard let answer = ac?.textFields?[0].text else { return  }
             self?.submit(answer)
             
         }
         ac.addAction(submitAction)
         present(ac, animated: true)
         
        }
    func submit(_ answer: String) {
        let lowerCased = answer.lowercased()
        usedWords.insert(lowerCased, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    func startGame () {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

}

