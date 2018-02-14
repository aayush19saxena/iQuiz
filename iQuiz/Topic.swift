//
//  Topic.swift
//  iQuiz
//
//  Created by Aayush  Saxena on 2/13/18.
//  Copyright © 2018 Aayush  Saxena. All rights reserved.
//

import UIKit

class Topic: NSObject {
    var questions: [Question] = []
    var topicTitle: String = ""
    var topicDescription: String = ""
    var topicIcon: String = ""
    
    init(_ topicTitle : String, _ topicDescription : String, _ icon : String) {
        self.topicTitle = topicTitle
        self.topicDescription = topicDescription
        self.topicIcon = icon
    }
}
