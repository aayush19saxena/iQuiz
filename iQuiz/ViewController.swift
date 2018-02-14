//
//  ViewController.swift
//  iQuiz
//
//  Created by Aayush  Saxena on 2/7/18.
//  Copyright © 2018 Aayush  Saxena. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var topicList: [Topic] = []
    
    @IBAction func btnSettings(_ sender: UIBarButtonItem) {
        print("User has pressed the settings button.")
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
                                        NSLog("\"OK\" pressed.")
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { _ in
                                        NSLog("\"Cancel\" pressed.")
        }))
        self.present(alert, animated: true, completion: {
            NSLog("The completion handler fired")
        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ViewControllerTableViewCell
        let topic =  self.topicList[indexPath.row]
        cell.quizLogo.image = UIImage(named: topic.topicIcon + ".jpg")
        cell.quizLabel.text = topic.topicTitle
        cell.quizDescription.text = topic.topicDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell #\(indexPath.row) selected")
        let questionViewController = self.storyboard?.instantiateViewController(withIdentifier: "questionView") as! QuestionViewController
        questionViewController.topic = self.topicList[indexPath.row]
        self.present(questionViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let mathTopic = Topic("Mathematics", "Additon & Subtraction", "math")
        let marvelTopic = Topic("Marvel Super Heroes", "Marvel comics", "marvel")
        let scienceTopic = Topic("Science", "Scientific Theories", "science")
        
        let mathQuestion1 = Question("What is 15 - 3?", ["11", "12", "14", "15"], 2)
        let mathQuestion2 = Question("What is 81 - 85?", ["-4", "4", "2", "3"], 1)
        mathTopic.questions = [mathQuestion1, mathQuestion2]
        
        let marvelQuestion1 = Question("Which superhero can fly?", ["Thor", "Superman", "Flash", "Hulk"], 2)
        let marvelQuestion2 = Question("Which superhero runs super fast?", ["Hulk", "Superman", "Thor", "Flash"], 4)
        marvelTopic.questions = [marvelQuestion1, marvelQuestion2]
        
        let scienceQuestion1 = Question("What does Mn denote?", ["Magnesium", "Manganese", "Manganate", "Man"], 2)
        let scienceQuestion2 = Question("Who found Pasteurization?", ["Louis Pasteur", "Pasteur Graham", "Graham Bell", "Mr. Pasteur"], 1)
        scienceTopic.questions = [scienceQuestion1, scienceQuestion2]
        topicList = [mathTopic, marvelTopic, scienceTopic]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

