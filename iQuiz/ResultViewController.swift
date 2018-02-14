//
//  ResultViewController.swift
//  iQuiz
//
//  Created by Aayush  Saxena on 2/14/18.
//  Copyright © 2018 Aayush  Saxena. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var correctCount = 0
    var total = 0
    var topic: Topic?
    
    var percent = 0.0

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        percent = Double(correctCount) / Double(total)
        if percent < 0.5 {
            resultLabel.text = "You suck"
        } else if percent >= 0.5 && percent < 0.75 {
            resultLabel.text = "Better Luck next time"
        } else {
            resultLabel.text = "Nice! Keep it up! ;)"
        }
        
        scoreLabel.text = "\(correctCount) out of \(total)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
