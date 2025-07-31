//
//  Result.swift
//  QuizEngine
//
//  Created by Dinara Shadyarova on 01.08.2025.
//

import Foundation

struct Result<Question: Hashable, Answer> {
    let answers: [Question: Answer]
    let score: Int
}
