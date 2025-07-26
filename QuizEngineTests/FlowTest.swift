//
//  FlowTest.swift
//  FlowTest
//
//  Created by Dinara Shadyarova on 26.07.2025.
//

import XCTest
@testable import QuizEngine

final class FlowTest: XCTestCase {
    let router = RouterSpy()
    
    func test_start_withNoQuesitons_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToQuestion() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToNextQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    // MARK: Helpers
    func makeSUT(questions: [String]) -> Flow {
        Flow(router: router, questions: questions)
    }
}

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var answerCallback: Router.AnswerCallback = { _ in }
    
    func route(to question: String, answerCallback: @escaping Router.AnswerCallback) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
}
