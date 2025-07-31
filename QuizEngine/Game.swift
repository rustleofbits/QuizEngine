//
//  Game.swift
//  QuizEngine
//
//  Created by Dinara Shadyarova on 01.08.2025.
//

import Foundation

class Game<Question: Hashable, Answer, R: Router> where Question == R.Question, Answer == R.Answer {
    private let flow: Flow<Question, Answer, R>
    
    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

func startGame<Question: Hashable, Answer: Equatable, R: Router>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
    let flow = Flow(router: router, questions: questions) { answers in
        scoring(answers, correctAnswers: correctAnswers)
    }
    flow.start()
    return Game(flow: flow)
}

func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    answers.reduce(0) { score, tuple in
        score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
