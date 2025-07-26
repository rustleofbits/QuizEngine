//
//  Flow.swift
//  Flow
//
//  Created by Dinara Shadyarova on 26.07.2025.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func route(
        to question: String,
        answerCallback: @escaping AnswerCallback
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
            router.route(to: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        }
    }
    
    func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] _ in
            guard let self = self else { return }
            if let currentQuestionIndex = self.questions.firstIndex(of: question),
               currentQuestionIndex+1 < questions.count {
                let nextQuestion = self.questions[currentQuestionIndex + 1]
                router.route(to: nextQuestion, answerCallback: routeNext(from: nextQuestion))
            }
        }
    }
}
