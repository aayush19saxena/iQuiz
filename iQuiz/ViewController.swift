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
    var alternativeURL = "https://api.myjson.com/bins/eabyh"
    var url = "http://tednewardsandbox.site44.com/questions.json"
    var settings = UserDefaults.standard.string(forKey: "settings-url")
    
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
        getData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        if(!self.loadSettings()) {
            self.createSettings()
        }
        
    }
    
    func getData() {
        self.topicList = []
        var url = self.settings
        print("URL is: \(url)")
        if (url == nil || url == "") {
            // if there is no url in the settings
            url = "http://tednewardsandbox.site44.com/questions.json"
        }
        print("Inside getData-- attempting to download from the URL: \(url)")
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
                                print(jsonData)
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
    
    func createSettings() {
        let settingsKey = "settings-url"
        NSLog("Creating settings URL with key: \(settingsKey)")
        UserDefaults.standard.set(url, forKey: settingsKey)
        NSLog(UserDefaults.standard.string(forKey: settingsKey)!)
    }
    
    func loadSettings() -> Bool {
        if(self.settings != nil) {
            self.url = self.settings!
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSettings(_ sender: UIBarButtonItem) {
        print("User has pressed the settings button.")
        let alert = UIAlertController(title: "Retrieve JSON", message: "Type in a valid URL", preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter URL"
        }
        alert.addAction(UIAlertAction(title: "Check now", style: .default) {
            UIAlertAction in
            let url = alert.textFields![0] as UITextField
            print("Updating settings URL with \(url)")
            UserDefaults.standard.set(url.text, forKey: "settings-url")
            self.settings = UserDefaults.standard.string(forKey: "settings-url")
            self.getData()
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: { _ in
                                        NSLog("\"Cancel\" pressed.")
        }))
        self.present(alert, animated: true, completion: {
            NSLog("Settings handler fired")
        })
        
    }


}

