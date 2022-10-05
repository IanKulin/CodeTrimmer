//
//  ContentView.swift
//  CodeTrimmer
//
//  Created by Ian Bailey on 3/10/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var codeSnippet = ""
    @State private var fontSize = 12.0

    // swiftlint:disable todo
    // TODO: initialise window at a reasonable size on first run
    // TODO: add "copy all" button
    // TODO: icons
    // TODO: Help Text
    // TODO: Web page (Github?)
    // TODO: Animate the trimming
    // TODO: installer
    // swiftlint:enable todo

    var displayFont: Font {
        Font.system(
            size: CGFloat(fontSize),
            design: .monospaced
        )
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
                                Text("A").font(.system(size: 16))) {
                                    Text("Font Size (\(Int(fontSize)))")
                                }
                                .frame(width: 150)
                        Divider()
                        Button("Strip Spaces") {
                            codeSnippet = stripSpaces(codeSnippet)
                        }
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
        // swiftlint:disable trailing_closure
        let leadingSpaces = line.prefix(while: { $0 == " " }).count
        // swiftlint:enable trailing_closure
        minCount = leadingSpaces < minCount ? leadingSpaces : minCount
    }
    // step though the lines again, and trim the min amount from each line
    for index in 0..<lines.count {
        lines[index] = String(lines[index].dropFirst(minCount))
    }
    // stitch it back up
    return lines.joined(separator: "\n")
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
