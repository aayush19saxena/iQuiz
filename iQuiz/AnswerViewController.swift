//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Aayush  Saxena on 2/13/18.
//  Copyright © 2018 Aayush  Saxena. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var decisionLabel: UILabel!
    
    var currentQuestion: Question?
    var topic: Topic?
    var answer = 0
    var correctCount = 0
    var questionNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = "Question #\(questionNum): " + (currentQuestion?.question)!
        correctAnswerLabel.text = currentQuestion?.options[((currentQuestion?.correctAnswerIndex)! - 1)]
        if(answer == currentQuestion?.correctAnswerIndex) {
            correctCount += 1
            decisionLabel.text = "You are correct"
        } else {
            decisionLabel.text = "Incorrect Answer :("
        }
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        if questionNum < (topic?.questions.count)! {
            performSegue(withIdentifier: "nextQuestion", sender: self)
        } else {
            let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
            resultViewController.total = self.questionNum
            resultViewController.correctCount = self.correctCount
            resultViewController.topic = self.topic
            self.present(resultViewController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let questionView = segue.destination as! QuestionViewController
            questionView.topic = self.topic
            questionNum += 1
            questionView.questionNum = self.questionNum
            questionView.correctCount = self.correctCount
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
