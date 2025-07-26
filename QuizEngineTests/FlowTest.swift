//
//  FlowTest.swift
//  FlowTest
//
//  Created by Dinara Shadyarova on 26.07.2025.
//

import XCTest
@testable import QuizEngine

final class FlowTest: XCTestCase {
    
    func test_start_withNoQuesitons_doesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router, questions: [])
        sut.start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router, questions: ["Q1"])
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_routesToSecondQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router, questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
}

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var answerCallback: (String) -> Void = { _ in }
    
    func route(to question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
}
