///
//  Lexer.swift
//  Tracer
//
//  Created by Felix on 2019/8/12.
//

import Foundation

let uselessKeys: [Character] = ["\n", "\r", "\t", " "]

public enum LexerError: Error {
    case NotMatch
}

public class LLexer {
    
    fileprivate let filePath: String
    fileprivate let fileSource: String
    
    fileprivate var curIdx: String.Index
    
    public init(_ file: String) {
        filePath = file
        
        do {
            fileSource = try String(contentsOfFile: file, encoding: .utf8).rmComments
        } catch {
            fileSource = ""
        }
        curIdx = fileSource.startIndex
    }
}

extension LLexer {
    public var tokens: [Token] {
        var tks = [Token]()
        var t = next()
        
        while t.type != .EOF {
            tks.append(t)
            t = next()
        }
        return tks
    }
}

extension LLexer {
    public func next() -> Token {
        while !fileEnd {
            switch current {
            case uselessKeys[0], uselessKeys[1], uselessKeys[2], uselessKeys[3]:
                skipUseless()
                
            case "+":
                pass()
                return Token(type: .plus, text: "+")
                
            case "-":
                pass()
                if !fileEnd && current == ">" {
                    pass()
                    return Token(type: .rightArrow, text: "->")
                }
                return Token(type: .minus, text: "-")
                
            case "*":
                pass()
                return Token(type: .asterisk, text: "*")
                
            case "\\":
                pass()
                return Token(type: .backslash, text: "\\")
                
            case "/":
                pass()
                return Token(type: .forwardSlash, text: "/")
                
            case "@":
                return atBlabla()
                
            case "#":
                return poundBlabla()
                
            case "$":
                pass()
                return Token(type: .dollar, text: "$")
                
            case "(":
                pass()
                return Token(type: .openParen, text: "(")
                
            case ")":
                pass()
                return Token(type: .closeParen, text: ")")
                
            case "[":
                pass()
                return Token(type: .openBracket, text: "[")
                
            case "]":
                pass()
                return Token(type: .closeBracket, text: "]")
                
            case "{":
                pass()
                return Token(type: .openBrace, text: "{")
                
            case "}":
                pass()
                return Token(type: .closeBrace, text: "}")
                
            case "<":
                pass()
                return Token(type: .less, text: "<")
                
            case ">":
                pass()
                return Token(type: .greater, text: ">")
                
            case ":":
                pass()
                return Token(type: .colon, text: ":")
                
            case ",":
                pass()
                return Token(type: .comma, text: ",")
                
            case ";":
                pass()
                return Token(type: .semicolon, text: ";")
                
                
            case "=":
                pass()
                return Token(type: .equal, text: "=")
                
            case "\"":
                pass()
                return Token(type: .doubleQuotation, text: "\"")
                
            case "^":
                pass()
                return Token(type: .caret, text: "^")
                
            case ".":
                pass()
                return Token(type: .dot, text: ".")
                
            default:
                
                if current.isLetter || current == "_" {
                    
                    let w = currentWord
                    switch w {
                    case "super":
                        return Token(type: .super, text: "super")
                    case "static":
                        return Token(type: .static, text: "static")
                    case "return":
                        return Token(type: .super, text: "return")
                    default:
                        break
                    }
                    return Token(type: .name, text: w)
                }
                pass()
                continue
            }
        }
        return Token(type: .EOF, text: "")
    }
}

extension LLexer {
    
    /// current file is finished
    var fileEnd: Bool {
        return curIdx == fileSource.endIndex
    }
    
    /// current character
    var current: Character {
        return fileSource[curIdx]
    }
    
    var currentWord: String {
        guard !fileEnd else { return "" }
        
        var result = [Character]()
        var c: Character
        while !fileEnd {
            c = current
            if c.isLetter || c.isNumber || c == "_" {
                result.append(c)
                pass()
            }else {
                break
            }
        }
        return String(result)
    }
    
    /// move curIdx to next
    func pass() {
        curIdx = fileSource.index(after: curIdx)
    }
    
    /// skit useless char
    func skipUseless() {
        while !fileEnd && uselessKeys.contains(current) {
            pass()
        }
    }
    
}

extension LLexer {
    
    
    /// match the word with currentIndex
    ///
    /// - Parameter str: word
    /// - Throws: if doesn't match
    func match(str: String) throws {
        
        var idx = str.startIndex
        while idx != str.endIndex && !fileEnd {
            if str[idx] != current {
                throw LexerError.NotMatch
            }
            idx = str.index(after: idx)
            pass()
        }
        if idx != str.endIndex {
            throw LexerError.NotMatch
        }
    }
    
    /// check if match special keyword
    ///
    /// - Parameter str: word
    /// - Returns: if matches
    func check(str: String) -> Bool {
        
        let idx = curIdx
        do {
            try match(str: str)
            return true
        } catch {
            curIdx = idx
            return false
        }
    }
    
    /// found specialWord start with '@'
    func atBlabla() -> Token {
        if check(str: "@interface") {
            return Token(type: .atInterface, text: "@interface")
        }else if check(str: "@implementation") {
            return Token(type: .atImplementation, text: "implementation")
        }else if check(str: "@end") {
            return Token(type: .atEnd, text: "@end")
        }else if check(str: "@import") {
            return Token(type: .atImport, text: "@import")
        }else if check(str: "@class") {
            return Token(type: .atClass, text: "@class")
        }else if check(str: "@protocol") {
            return Token(type: .atProtocol, text: "@protocol")
        }
        pass()
        return Token(type: .at, text: "@")
    }
    
    /// found specialWord start with '#'
    func poundBlabla() -> Token {
        if check(str: "#import") {
            return Token(type: .poundImport, text: "#import")
        }
        pass()
        return Token(type: .pound, text: "#")
    }
}
