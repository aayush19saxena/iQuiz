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
        let alert = UIAlertController(title: "Retrieve JSON", message: "Type in a valid URL", preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter URL"
        }
        alert.addAction(UIAlertAction(title: "Check now", style: .default) {
            UIAlertAction in
            let url = alert.textFields![0] as UITextField
            self.getData(url.text)
            self.tableView.reloadData()
        })
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
        //cell.quizLogo.image = UIImage(named: topic.topicIcon + ".jpg")
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
        getData("http://tednewardsandbox.site44.com/questions.json")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        /*
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
        */
        
    }
    
    func getData(_ url: String? = "http://tednewardsandbox.site44.com/questions.json") {
        self.topicList = []
        var u = url
        if (u == nil || u == "") {
            u = "http://tednewardsandbox.site44.com/questions.json"
        }
        print("Inside getData")
        let urlString = URL(string: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: OperationQueue.current)
        var jsonData : NSArray = []
        let fileManager = FileManager.default
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questions.json")
        let content = NSData(contentsOf: path)
        if checkConnectionStatus() {
            let task = session.dataTask(with: urlString!) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        do {
                            jsonData = (try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray)!
                            do {
                                try jsonData.write(to: path)
                                print("JSON data written! to \(path)")
                            } catch {
                                if content != nil {
                                    jsonData = NSArray(contentsOf: path)!
                                }
                            }
                        } catch {
                            NSLog("Unable to write to file")
                        }
                    } else {
                        if let error = error {
                            NSLog(error.localizedDescription)
                        } else {
                            NSLog("Request not successful. Status code: \(response.statusCode)")
                        }
                    }
                } else if let error = error {
                    NSLog(error.localizedDescription)
                    let alert = UIAlertController(title: "Download failed", message: "Can't download the json from the URL", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .default,
                                                  handler: { _ in
                                                    NSLog("\"OK\" pressed.")
                    }))
                    self.present(alert, animated: true, completion: {
                        NSLog("The download failed handler fired")
                    })
                }
                
                if (jsonData.count > 0) {
                    for index in 0...jsonData.count - 1 {
                        let topicData = jsonData[index] as! NSDictionary
                        let topicTitle = topicData.value(forKey: "title") as! String
                        let topicDesc = topicData.value(forKey: "desc") as! String
                        let topic = Topic(topicTitle, topicDesc, "")
                        let questionData = topicData.value(forKey: "questions") as! NSArray
                        var questions : [Question] = []
                        
                        for questionIndex in 0...questionData.count - 1 {
                            let questionValue = questionData[questionIndex] as! NSDictionary
                            let question = Question(questionValue.value(forKey: "text") as! String, questionValue.value(forKey: "answers") as! [String], Int(questionValue.value(forKey: "answer") as! String)!)
                            questions.append(question)
                        }
                        topic.questions = questions
                        self.topicList.append(topic)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                // terminates all outstanding tasks i.e. failed HTTP requests
                session.invalidateAndCancel()
            }
            
            task.resume()
        } else {
            print("JSON data retrived offline")
            jsonData = NSArray(contentsOf: path)!
            if (jsonData.count > 0) {
                for index in 0...jsonData.count - 1 {
                    let topicData = jsonData[index] as! NSDictionary
                    let topicTitle = topicData.value(forKey: "title") as! String
                    let topicDesc = topicData.value(forKey: "desc") as! String
                    let topic = Topic(topicTitle, topicDesc, "")
                    let questionData = topicData.value(forKey: "questions") as! NSArray
                    var questions : [Question] = []
                    
                    for questionIndex in 0...questionData.count - 1 {
                        let questionValue = questionData[questionIndex] as! NSDictionary
                        let question = Question(questionValue.value(forKey: "text") as! String, questionValue.value(forKey: "answers") as! [String], Int(questionValue.value(forKey: "answer") as! String)!)
                        questions.append(question)
                    }
                    topic.questions = questions
                    self.topicList.append(topic)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        tableView.reloadData()
    }
    
    func checkConnectionStatus() -> Bool {
        if currentConnectionStatus == .notReachable {
            NSLog("No internet connection")
            let alert = UIAlertController(title: "Connection Status failed", message: "Can't connect to the internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { _ in
                                            NSLog("\"OK\" pressed.")
            }))
            self.present(alert, animated: true, completion: {
                NSLog("The connection failed handler fired")
            })
            return false
        } else {
            NSLog("Connected to the internet")
            return true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

