//===----------------------------------------------------------*- Swift -*-===//
//
// Created by wuyikai on 2024/5/23.
// Copyright © 2024 wuyikai. All rights reserved.
//
//===----------------------------------------------------------------------===//

import Foundation

/// Person
public struct Person {
    /// person's name
    public let name: String
    /// person's age
    public let age: Int
    
    /// initial
    public init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    /// person can speak
    public func speak() {
        print(name, age, "speak")
    }
}
