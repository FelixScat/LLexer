import XCTest
@testable import LLexer

final class LLexerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(LLexer().text, "Hello, World!")
        
        let path = "/Users/felix/Documents/GitLab/TDFTestProject/Example/TDFTestProject/TDFAppDelegate.m"
        
        let lexer = LLexer(path)
        
        let tks = lexer.tokens
        
        
        
        XCTAssert(tks.count > 0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
