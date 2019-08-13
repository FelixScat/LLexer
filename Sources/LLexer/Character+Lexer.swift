//
//  Character+Lexer.swift
//  Lexer
//
//  Created by Felix on 2019/8/12.
//

import Foundation


extension Character {
    
    /// is letter
    public var isLetter: Bool {
        return (self >= "a" && self <= "z") || (self >= "A" && self <= "Z")
    }
    
    /// is number
    public var isNumber: Bool {
        return (self >= "0") && (self <= "9")
    }
}
