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
    
    func test_start_withNoQuesitons_routesToResult() {
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult?.answers, [:])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuesitons_routesToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedResult?.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_start_withOneQuesiton_doesNotRouteToResult() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuesitons_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuesitons_scores() {
        var resultAnswer: [String: String] = [:]
        let scoring: ([String: String]) -> Int = { result in
            resultAnswer = result
            return 3
        }
        
        let sut = makeSUT(questions: ["Q1", "Q2"], scoring: scoring)
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedResult?.score, 3)
        XCTAssertEqual(router.routedResult?.answers, resultAnswer)
    }
    
    // MARK: Helpers
    func makeSUT(
        questions: [String],
        scoring: @escaping ([String: String]) -> Int = { _ in 0 }
    ) -> Flow<String, String, RouterSpy> {
        Flow(router: router, questions: questions, scoring: scoring)
    }
}
