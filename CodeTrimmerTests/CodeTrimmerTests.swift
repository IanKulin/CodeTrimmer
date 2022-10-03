//
//  CodeTrimmerTests.swift
//  CodeTrimmerTests
//
//  Created by Ian Bailey on 3/10/2022.
//

// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable required_deinit
// swiftlint:disable indentation_width

@testable import CodeTrimmer
import XCTest

final class CodeTrimmerTests: XCTestCase {

    func testStripSpaces() throws {
        var testString =
        """
        single line string no spaces
        """
        var resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == testString, testString)

        testString =
        """
            single line 4 spaces
        """
        resultString = stripSpaces(testString)
        XCTAssertFalse(resultString == testString, testString)
        XCTAssertTrue(testString.dropFirst(4) == resultString, testString)

        testString = ""
        resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == testString, "Empty string")
        XCTAssertTrue(resultString.isEmpty, "Empty string")

        testString =
        """
            two line 4 spaces
            second line 4 spaces
        """
        resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == "two line 4 spaces\nsecond line 4 spaces", "Two lines 4 spaces")

        testString =
        """
            first line 4 spaces
              second line 6 spaces
        """
        resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == "first line 4 spaces\n  second line 6 spaces", "Two lines 4 & 6 spaces")

        testString =
        """
              first line 6 spaces
            second line 4 spaces
        """
        resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == "  first line 6 spaces\nsecond line 4 spaces", "Two lines 6 & 4 spaces")

        testString =
        """
              first line 6 spaces
            second line 4 spaces
          third line 2 spaces
        """
        resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == "    first line 6 spaces\n  second line 4 spaces\nthird line 2 spaces", "three lines 6 & 4 & 2 spaces")

        // test a hunk of code
        testString =
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
        resultString = stripSpaces(testString)
        XCTAssertTrue(resultString == testString, "Hunk fail")
    }

}
