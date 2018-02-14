//
//  Question.swift
//  iQuiz
//
//  Created by Aayush  Saxena on 2/12/18.
//  Copyright © 2018 Aayush  Saxena. All rights reserved.
//

import UIKit

class Question: NSObject {
    var question = ""
    var options: [String] = []
    var correctAnswerIndex = 0
    
    init(_ question: String, _ options: [String], _ correctAnswerIndex: Int) {
        self.question = question
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
    }
}
