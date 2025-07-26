//
//  Flow.swift
//  Flow
//
//  Created by Dinara Shadyarova on 26.07.2025.
//

import Foundation

protocol Router {
    func route(
        to question: String,
        answerCallback: @escaping (String) -> Void
    )
}

class Flow {
    let router: Router
    let questions: [String]
    
    init(router: Router, questions: [String]) {
        self.router = router
        self.questions = questions
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.route(to: firstQuestion) { [weak self] _ in
                guard let self = self else { return }
                let firstQuestionIndex = self.questions.firstIndex(of: firstQuestion)!
                let nextQuestion = self.questions[firstQuestionIndex + 1]
                router.route(to: nextQuestion) { _ in }
            }
        }
    }
}
