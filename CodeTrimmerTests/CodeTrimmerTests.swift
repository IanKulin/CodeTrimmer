//
//  CodeTrimmerTests.swift
//  CodeTrimmerTests
//
//  Created by Ian Bailey on 3/10/2022.
//

// swiftlint:disable required_deinit
// swiftlint:disable indentation_width

@testable import CodeTrimmer
import XCTest

final class CodeTrimmerTests: XCTestCase {

    func testStripSpaces01() throws {
        let testString =
        """
        single line string no spaces
        """
        let resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == testString, testString)
    }

    func testStripSpaces02() throws {
        let testString =
        """
            single line 4 spaces
        """
        let resultString = stripSpaces(testString)
        XCTAssertFalse(resultString == testString, testString)
        XCTAssertTrue(testString.dropFirst(4) == resultString, testString)
    }

    func testStripSpaces03() throws {
        let testString = ""
        let resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == testString, "Empty string")
        XCTAssertTrue(resultString.isEmpty, "Empty string")
    }

    func testStripSpaces04() throws {
        let testString =
        """
            two line 4 spaces
            second line 4 spaces
        """
        let resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == "two line 4 spaces\nsecond line 4 spaces", "Two lines 4 spaces")
    }

    func testStripSpaces05() throws {
        let testString =
        """
            first line 4 spaces
              second line 6 spaces
        """
        let resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == "first line 4 spaces\n  second line 6 spaces", "Two lines 4 & 6 spaces")
    }

    func testStripSpaces06() throws {
        let testString =
        """
              first line 6 spaces
            second line 4 spaces
        """
        let resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == "  first line 6 spaces\nsecond line 4 spaces", "Two lines 6 & 4 spaces")
    }

    func testStripSpaces07() throws {
        let testString =
        """
              first line 6 spaces
            second line 4 spaces
          third line 2 spaces
        """
        let resultString = stripSpaces(testString)
        // swiftlint:disable line_length
        XCTAssertTrue(resultString == "    first line 6 spaces\n  second line 4 spaces\nthird line 2 spaces", "three lines 6 & 4 & 2 spaces")
        // swiftlint:enable line_length
    }

    // swiftlint:disable function_body_length
    func testStripSpaces08() throws {
        // test a hunk of code

        let testString =
        """
        import SwiftUI

        struct ContentView: View {
            @State private var codeSnippet = ""
            @State private var fontSize = 12.0

            // TODO: initialise window at a reasonable size on first run
            // TODO: add "copy all" button
            // TODO: icons
            // TODO: Help Text
            // TODO: Web page (Github?)
            // TODO: Animate the trimming
            // TODO: installer


            var displayFont: Font {
                Font.system(size: CGFloat(fontSize),
                            design: .monospaced)
            }


            var body: some View {
                Section {
                    TextEditor(text: $codeSnippet)
                        .foregroundColor(.primary)
                        .padding()
                        .font(displayFont)
                        .toolbar {
                            ToolbarItemGroup {
                                Slider(
                                    value: $fontSize,
                                    in: 8...120,
                                    minimumValueLabel:
                                        Text("A").font(.system(size: 8)),
                                    maximumValueLabel:
                                        Text("A").font(.system(size: 16)))
                                {
                                    Text("Font Size ((Int(fontSize)))")
                                }
                                .frame(width: 150)
                                Divider()
                                Button("Strip Spaces")
                                    { codeSnippet = stripSpaces(codeSnippet) }
                                    .background(.white)
                                    .foregroundColor(.primary)
                                    .cornerRadius(5)
                                    .shadow(radius: 2)
                            }
                        }
                        .navigationTitle("CodeTrimmer")
                }
            }
        }


        func stripSpaces(_ codeLines: String ) -> String {
            // break into lines
            var lines = codeLines.components(separatedBy: "\n")
            var minCount = Int.max
            // step though the lines and count how many spaces, save the minimum amount
            for line in lines {
                let leadingSpaces = line.prefix(while: { $0 == " " }).count
                minCount = leadingSpaces < minCount ? leadingSpaces : minCount
            }
            // step though the lines again, and trim the min amount from each line
            for i in 0..<lines.count {
                lines[i] = String(lines[i].dropFirst(minCount))
            }
            // stitch it back up
            return lines.joined(separator: "\n")
        }


        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }


        """
        let resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == testString, "Hunk fail")
    }
    // swiftlint:enable function_body_length

}
