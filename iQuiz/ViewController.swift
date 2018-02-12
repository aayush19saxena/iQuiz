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
    
    let quizLabels = ["Marvel Super Heroes", "Mathematics", "Science"]
    let quizDescriptions = ["Marvel comics", "Addition & Subtraction", "Scientific Theories"]
    let quizLogos = ["marvel", "math", "science"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ViewControllerTableViewCell
        cell.quizLogo.image = UIImage(named: quizLogos[indexPath.row] + ".jpg")
        cell.quizLabel.text = quizLabels[indexPath.row]
        cell.quizDescription.text = quizDescriptions[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

