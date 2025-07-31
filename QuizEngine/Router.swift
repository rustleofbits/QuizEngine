//
//  Router.swift
//  QuizEngine
//
//  Created by Dinara Shadyarova on 01.08.2025.
//

protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(
        question: Question,
        answerCallback: @escaping (Answer) -> Void
    )
    func routeTo(result: Result<Question, Answer>)
}
