//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Aayush  Saxena on 2/13/18.
//  Copyright © 2018 Aayush  Saxena. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var topic: Topic?
    var questionNum = 1
    var question: Question?
    var selectedAnswer = 0
    var correctCount = 0
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var choice1: UIButton!
    @IBOutlet weak var choice2: UIButton!
    @IBOutlet weak var choice3: UIButton!
    @IBOutlet weak var choice4: UIButton!
    
    @IBAction func answerTapped(_ sender: UIButton) {
        choice1.backgroundColor = UIColor.lightGray
        choice2.backgroundColor = UIColor.lightGray
        choice3.backgroundColor = UIColor.lightGray
        choice4.backgroundColor = UIColor.lightGray
        sender.backgroundColor = UIColor.blue
        selectedAnswer = sender.tag
    }
    
    @IBAction func goToAnswer(_ sender: Any) {
        let answerViewController = self.storyboard?.instantiateViewController(withIdentifier: "answerView") as! AnswerViewController
        answerViewController.topic = self.topic
        answerViewController.currentQuestion = self.question
        answerViewController.answer = self.selectedAnswer
        answerViewController.questionNum = self.questionNum
        answerViewController.correctCount = self.correctCount
        self.present(answerViewController, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        question = topic?.questions[questionNum - 1]
        questionTitle.text = "Question #\(questionNum): " + (question?.question)!
        choice1.setTitle(question?.options[0], for: .normal)
        choice2.setTitle(question?.options[1], for: .normal)
        choice3.setTitle(question?.options[2], for: .normal)
        choice4.setTitle(question?.options[3], for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
