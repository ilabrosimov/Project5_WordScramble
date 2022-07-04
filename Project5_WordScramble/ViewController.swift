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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "NewGame", style: .plain, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
                                                            
        //Находим путь, где лежит наш старт.тхт, файл открывается как URL, а извлекаются из него String(contentsOf)
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
         let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
             guard let answer = ac?.textFields?[0].text else { return  }
             self?.submit(answer)
             
         }
         ac.addAction(submitAction)
         present(ac, animated: true)
         
        }
    func submit(_ answer: String) {
        let lowerCased = answer.lowercased()
        guard isNotTitle(lowerCased) else {
            showAlert(title: "Do not use the same word", message: "Try another word")
            return
        }
        guard isShort(lowerCased) else {
            showAlert(title: "Is too short", message: "Try word with 3 and more letter")
            return
        }
        if  isOriginal(lowerCased) {
            if isPossible(lowerCased) {
                if isReal(lowerCased) {
                    usedWords.insert(lowerCased, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                }
                else {
                    showAlert(title: "Word is not real", message: "Make up the real word, you know!")
                }
                
            }
            else {
                showAlert(title: "Word is not possible", message: "Use letters from \(title!.lowercased())")
            }
        }
        else {
            showAlert(title: "Word is already used", message: "Try to make another word")
        }
        
    }
    func showAlert (title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    func isOriginal (_ word: String) ->Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible (_ word: String) ->Bool {
        guard var tempWord = title?.lowercased() else { return false}
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
            
        }
        return true
    }
    func isReal (_ word: String) ->Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func isShort (_ word: String) ->Bool {
        return  word.count > 3
    }
    func isNotTitle (_ word: String) ->Bool {
        
        return !(word == title)  ? true: false
    }
    
    @objc func startGame () {
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

