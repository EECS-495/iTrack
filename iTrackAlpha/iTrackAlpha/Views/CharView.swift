//
//  CharView.swift
//  Track
//
//  Created by Danielle Maraffino on 2/2/23.
//

import SwiftUI
import AVFoundation
import Combine
import NaturalLanguage

struct CharView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State private var cancellables = Set<AnyCancellable>()
    @Binding var state: Int
    @Binding var rowState: Int
    @Binding var charState: Int
    @Binding var content: String
    @Binding var contentInd: Int
    @Binding var prevState: Int
    @Binding var selectState: selectedState
    @Binding var highlightBackspace: Bool
    @Binding var queue: [Action]
    @Binding var value: Int
    @Binding var highlightCursor: Bool
    @Binding var playSound: Bool
    @State var currentCharId = 0
    @Binding var showConfirmation: Bool
    @Binding var showSave: Bool
    @Binding var customList: [CustomPhrase]
    @Binding var nextStateId: Int
    @Binding var prevButtonType: ButtonType
    @Binding var predictedWords: [String]
    @State var curPredText = ""
    @State var curPredTextInd = -1
    
    var charRows: [CharRow] {
        CharRows.filter { row in
            (row.CharType == charState)
        }
    }
    var body: some View {
        HStack {
            Spacer()
            ScrollViewReader { spot in
                VStack {
                        ScrollView{
                            ForEach(charRows) { row in
                                Button(action: {clickChar(character: row)}){
                                    Text(row.character)
                                        .frame(width: scaleDim(row: row), height: scaleDim(row: row))
                                        .font(.largeTitle)
                                        .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                                        .foregroundColor(.black)
                                        .border(.blue, width: addBorder(row: row))
                                        .cornerRadius(8)
                                }
                                .padding(.leading, 140)
                                .padding(.vertical, 10)
                                .id(row.id - getFirstChar())
                            }
                        }
                        .onChange(of: currentCharId) { _ in
                            spot.scrollTo(currentCharId, anchor: .center)
                            print(currentCharId)
                        }
                    
                }
            }
            .modifier(GestureSwipeRight(state: $state, selectState: $selectState, prevState: $prevState, rowState: $rowState))
            .onChange(of: value ) { _ in
                if !queue.isEmpty {
                    let action = queue.first!.actionType
                    if action == ActionType.blink {
                        registerBlink()
                        queue.removeFirst()
                    } else {
                        registerGaze(action: action)
                        queue.removeFirst()
                    }
                }
            }
            VStack {
                // clear button
                Button(action: {print("CLEAR TEXT")}){
                    Text("Clear")
                        .frame(width: clearWidth(), height: clearHeight())
                        .foregroundColor(.black)
                        .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                        .border(.blue, width: clearBorder())
                        .cornerRadius(8)
                }
                .padding([.trailing], 55)
                .padding([.leading], 70)
                .padding([.top, .bottom], 10)
                Spacer()
                // predictive text
                ForEach(predictedWords, id: \.self) { word in
                    Button(action: {
                        replaceCurrentWordWithPrediction(predWord: word, predWordInd: predictedWords.firstIndex(of: word) ?? 0)
                    }) {
                        Text(word)
                            .frame(width: dimPredWidth(word: word), height: dimPredHeight(word: word))
                            .background(Color(red: 0.83, green: 0.83, blue: 0.83))
                            .foregroundColor(.black)
                            .border(.blue, width: addPredBorder(word: word))
                            .cornerRadius(8)
                    }
                    .padding([.trailing], 55)
                    .padding([.leading], 70)
                    .padding([.top, .bottom], 10)
                }
                .padding(.bottom, 8)
                Spacer()
            }
        }
    }
    
    private func clearHeight() -> CGFloat {
        if selectState.buttonType == ButtonType.clear {
            return 60
        } else {
            return 40
        }
    }
    
    private func clearWidth() -> CGFloat {
        if selectState.buttonType == ButtonType.clear {
            return 110
        } else {
            return 90
        }
    }
    
    private func clearBorder() -> CGFloat {
        if selectState.buttonType == ButtonType.clear {
            return 3.0
        } else {
            return 0.0
        }
    }
    
    private func clearText() {
        content = ""
        contentInd = 0
        predictedWords = []
    }
    
    private func goToClear() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.clear
        selectState.buttonId = 0
    }
    
    private func dimPredHeight(word: String) -> CGFloat {
        if selectState.buttonType == ButtonType.predText && curPredText == word {
            return 60
        } else {
            return 40
        }
    }
    
    private func dimPredWidth(word: String) -> CGFloat {
        if selectState.buttonType == ButtonType.predText && curPredText == word {
            return 110
        } else {
            return 90
        }
    }
    
    private func addPredBorder(word: String) -> CGFloat {
        if selectState.buttonType == ButtonType.predText && curPredText == word {
            return 3.0
        } else {
            return 0.0
        }
    }
    
    private func goToPredText() {
        selectState.buttonType = ButtonType.predText
        selectState.buttonId = 0
        selectState.clickState = 1
        curPredText = predictedWords[0]
        curPredTextInd = 0
    }
    
    private func movePredTextUp() {
        if curPredTextInd == 0 {
            goToClear()
        } else {
            curPredText = predictedWords[curPredTextInd - 1]
            curPredTextInd = curPredTextInd - 1
        }
    }
    
    private func movePredTextDown() {
        if curPredTextInd == predictedWords.count - 1 {
            return
        } else {
            curPredText = predictedWords[curPredTextInd + 1]
            curPredTextInd = curPredTextInd + 1
        }
    }
    
    private func registerBlink() {
        if selectState.buttonType == ButtonType.backspace {
            deleteChar()
        } else if selectState.buttonType == ButtonType.addNewPhrase {
            if playSound {
                makeSound()
            }
            savePhrase()
        } else if selectState.buttonType == ButtonType.char {
            updatePredictedWords()
            if showConfirmation {
                prevState = 2
                state = 4
                nextStateId = 1
                selectState.clickState = 1
                selectState.buttonType = ButtonType.confirm
                selectState.isNo = false
            } else {
                // add text to content
                var count: Int = 0
                var content1: String = ""
                var content2: String = ""
                let character = CharRows.filter { row in
                    row.id == selectState.buttonId
                }[0]
                for char in Array(content) {
                    if count >= contentInd {
                        break
                    }
                    content1 = content1 + String(char)
                    count = count + 1
                }
                count = 0
                for char in Array(content) {
                    if count >= contentInd {
                        content2 = content2 + String(char)
                    }
                    count = count + 1
                }
                content = content1 + character.character + content2
                contentInd = contentInd + 1
                state = 1
                selectState.clickState = 1
                selectState.buttonType = ButtonType.row
                selectState.buttonId = getFirstRow()
            }
        } else if selectState.buttonType == ButtonType.exit {
            if playSound {
                makeSound()
            }
            exit()
        } else if selectState.buttonType == ButtonType.predText {
            if playSound {
                makeSound()
            }
            replaceCurrentWordWithPrediction(predWord: curPredText, predWordInd: curPredTextInd)
        } else if selectState.buttonType == ButtonType.clear {
            if playSound {
                makeSound()
            }
            clearText()
        }
    }
    
    private func registerGaze(action: ActionType) {
        if action == ActionType.up {
            goUp()
        } else if action == ActionType.down {
            goDown()
        } else if action == ActionType.left {
            goLeft()
        } else if action == ActionType.right {
            goRight()
        }
    }
    
    
    private func goUp() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.char && curId - getFirstChar() == 0 {
            if showSave {
                highlightAddPhrase()
            } else {
                // go to backspace
                goToBackspace()
            }
            /*if !predictedWords.isEmpty{
                goToPredText()
            } else {
                if showSave {
                    highlightAddPhrase()
                } else {
                    // go to backspace
                    goToBackspace()
                }
            }*/
        } else if curType == ButtonType.char && curId - getFirstChar() > 0 && curId - getFirstChar() < charRows.count {
            // go to button(id-1)
            goToChar(id: curId-1)
            currentCharId = curId - getFirstChar() - 1
        } else if curType == ButtonType.addNewPhrase || curType == ButtonType.exit {
            goToBackspace()
        } else if curType == ButtonType.predText {
            movePredTextUp()
        } else if curType == ButtonType.clear {
            goToBackspace()
        }
    }
    
    private func goDown() {
        let curType = selectState.buttonType
        let curId = selectState.buttonId
        if curType == ButtonType.backspace {
            highlightBackspace = false
            if showSave {
                highlightAddPhrase()
            } else {
                // go to button(0)
                //goToChar(id: getFirstChar())
                //currentCharId = 0
                goToClear()
            }
        } else if curType == ButtonType.char && curId - getFirstChar() < charRows.count - 1 {
            // go to button(id + 1
            goToChar(id: curId + 1)
            currentCharId = curId - getFirstChar() + 1
        } else if curType == ButtonType.cursor {
            highlightCursor = false
            if showSave {
                highlightExit()
            } else {
                //goToChar(id: getFirstChar())
                //currentCharId = 0
                goToChar(id: getFirstChar())
                currentCharId = 0
            }
        } else if curType == ButtonType.addNewPhrase || curType == ButtonType.exit {
            //goToChar(id: getFirstChar())
            //currentCharId = 0
            goToChar(id: getFirstChar())
            currentCharId = 0
        } else if curType == ButtonType.predText {
            movePredTextDown()
        } else if curType == ButtonType.clear {
            if !predictedWords.isEmpty {
                goToPredText()
            }
        }
    }
    
    private func goLeft() {
        let curType = selectState.buttonType
        if curType == ButtonType.char || curType == ButtonType.exit {
            // go to row view
            goToRows()
        } else if curType == ButtonType.backspace {
            if content.count > 0 {
                highlightBackspace = false
                goToCursor()
            }
        } else if curType == ButtonType.cursor {
            moveCursorLeft()
        } else if curType == ButtonType.addNewPhrase {
            highlightExit()
        } else if curType == ButtonType.predText {
            goToChar(id: getFirstChar())
            currentCharId = 0
        } else if curType == ButtonType.clear {
            goToChar(id: getFirstChar())
            currentCharId = 0
        }
    }
    
    private func goRight() {
        let curType = selectState.buttonType
        if curType == ButtonType.cursor {
            if contentInd == content.count {
                highlightCursor = false
                goToBackspace()
            } else {
                moveCursorRight()
            }
        } else if curType == ButtonType.exit {
            highlightAddPhrase()
        } else if curType == ButtonType.char {
            if !predictedWords.isEmpty {
                goToPredText()
            } else {
                goToClear()
            }
        }
    }
    
    private func goToRows() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.row
        selectState.buttonId = getFirstRow()
        state = 1
    }
    
    private func makeSound() {
        guard let soundURL = Bundle.main.url(forResource: "blinkTone.wav", withExtension: nil) else {
                    fatalError("Unable to find blinkTone.wav in bundle")
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
            audioPlayer.play()
    }
    
    private func goToCursor() {
        highlightCursor = true
        selectState.clickState = 1
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.cursor
    }
    
    private func moveCursorLeft() {
        if contentInd > 0 {
            contentInd = contentInd - 1
        }
    }
    
    private func moveCursorRight() {
        if contentInd < content.count {
            contentInd = contentInd + 1
        }
    }
    
    private func goToBackspace() {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.backspace
        selectState.buttonId = 0
        highlightBackspace = true
    }
    
    private func goToChar(id: Int) {
        selectState.clickState = 1
        selectState.buttonType = ButtonType.char
        selectState.buttonId = id
    }
    
    private func getFirstRow() -> Int {
        if rowState == 0 {
            return 0
        } else if rowState == 1 {
            return 6
        } else if rowState == 2 {
            return 10
        } else {
            return 3
        }
    }
    
    private func getFirstChar() -> Int {
        if charState == 0 {
            return 0
        } else if charState == 1 {
            return 10
        } else if charState == 2 {
            return 19
        } else if charState == 3 {
            return 52
        } else if charState == 4 {
            return 62
        } else if charState == 5 {
            return 72
        } else if charState == 6 {
            return 82
        } else if charState == 7 {
            return 87
        } else if charState == 8 {
            return 92
        } else if charState == 9 {
            return 26
        } else if charState == 10 {
            return 36
        } else {
            // charState == 11
            return 45
        }
    }
    
    private func deleteChar() {
        if contentInd > 0 {
            makeSound()
            var count: Int = 0
            var content1: String = ""
            var content2: String = ""
            for char in Array(content) {
                if count >= contentInd - 1 {
                    break
                }
                content1 = content1 + String(char)
                count = count + 1
            }
            count = 0
            for char in Array(content) {
                if count >= contentInd {
                    content2 = content2 + String(char)
                }
                count = count + 1
            }
            content = content1 + content2
            contentInd = contentInd - 1
            
            // Update predicted words
            updatePredictedWords()
        }
    }
    
    private func clickChar(character: CharRow) {
        // Update predicted words
        updatePredictedWords()
        
        if selectState.clickState == 0 {
            selectState.clickState = 1
            selectState.buttonType = ButtonType.char
            selectState.buttonId = character.id
        } else if selectState.clickState == 1 {
            if selectState.buttonType == ButtonType.char && selectState.buttonId == character.id {
                if showConfirmation {
                    prevState = 2
                    nextStateId = 1
                    state = 4
                    selectState.clickState = 0
                } else {
                    // add text to content
                    var count: Int = 0
                    var content1: String = ""
                    var content2: String = ""
                    let character = CharRows.filter { row in
                        row.id == selectState.buttonId
                    }[0]
                    for char in Array(content) {
                        if count >= contentInd {
                            break
                        }
                        content1 = content1 + String(char)
                        count = count + 1
                    }
                    count = 0
                    for char in Array(content) {
                        if count >= contentInd {
                            content2 = content2 + String(char)
                        }
                        count = count + 1
                    }
                    content = content1 + character.character + content2
                    contentInd = contentInd + 1
                    state = 1
                    selectState.clickState = 1
                    selectState.buttonType = ButtonType.row
                    selectState.buttonId = getFirstRow()
                }
            } else {
                selectState.buttonId = character.id
                selectState.buttonType = ButtonType.char
            }
        }
        // tells backspace another button has been pushed
        highlightBackspace = false
         
    }
    
    private func scaleDim(row: CharRow) -> CGFloat {
        if selectState.clickState == 1 && selectState.buttonType == ButtonType.char && selectState.buttonId == row.id {
            return 100
        } else {
            return 60
        }
    }
    
    private func addBorder(row: CharRow) -> CGFloat {
        if selectState.clickState == 1 && selectState.buttonType == ButtonType.char && selectState.buttonId == row.id {
            return 3
        } else {
            return 0
        }
    }
    
    private func savePhrase() {
        if (showConfirmation) {
            prevButtonType = ButtonType.addNewPhrase
            nextStateId = 5
            prevState = 2
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            state = 4
        } else {
            let newId = customList.count
            customList.append(CustomPhrase(id: newId, content: self.content))
            showSave = false
            content = ""
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            state = 5
        }
    }
    
    private func highlightAddPhrase() {
        if content.isEmpty {
            highlightExit()
        } else {
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.addNewPhrase
            selectState.clickState = 1
        }
    }
    
    private func highlightExit() {
        selectState.buttonId = 0
        selectState.buttonType = ButtonType.exit
        selectState.clickState = 1
    }
    
    private func exit() {
        // showSave = false
        goToCustomPhrases()
    }
    
    private func goToCustomPhrases() {
        if showConfirmation {
            if selectState.buttonType == ButtonType.exit {
                prevButtonType = ButtonType.exit
            } else {
                prevButtonType = ButtonType.enterPhrases
            }
            nextStateId = 5
            prevState = 2
            selectState.buttonId = 0
            selectState.buttonType = ButtonType.confirm
            selectState.isNo = false
            state = 4
        } else {
            if selectState.buttonType == ButtonType.exit {
                content = ""
                showSave = false
            }
            selectState.buttonType = ButtonType.customPhrase
            selectState.buttonId = 0
            selectState.clickState = 0
            state = 5
        }
    }
    
    
    private func predictWords(input: String, maxSuggestions: Int) -> [String] {
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = input
        
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther, .joinNames]
        let tags = tagger.tags(in: input.startIndex..<input.endIndex, unit: .word, scheme: .nameType, options: options).compactMap { $0.0 }
        
        var suggestions = [String]()
        
        for tag in tags {
            if let tokenRange = input.range(of: tag.rawValue) {
                let token = input[tokenRange]
                suggestions.append(String(token))
                if suggestions.count >= maxSuggestions {
                    break
                }
            }
        }
        
        return suggestions
    }
        
    private func updatePredictedWords() {

        let textChecker = UITextChecker()

        print("update_predict_word_called")
        let cursorIndex = content.index(content.startIndex, offsetBy: contentInd)

        

        let lastSpaceOrNewline = content[..<cursorIndex].rangeOfCharacter(from: .whitespacesAndNewlines, options: .backwards)?.upperBound

        let lastWordStartIndex = lastSpaceOrNewline ?? content.startIndex

        let lastWordRange = NSRange(lastWordStartIndex..<cursorIndex, in: content)

        

        if let completions = textChecker.completions(forPartialWordRange: lastWordRange, in: content, language: "en") {

            predictedWords = Array(completions.prefix(3))

            print("predict words:", predictedWords)

        } else {

            predictedWords = []

            print("predict words: nothing")

        }

    }
    
    private func replaceCurrentWordWithPrediction(predWord: String, predWordInd: Int) {

        if predictedWords.isEmpty {

            print("No predicted words available.")

            return

        }

        

        let cursorIndex = content.index(content.startIndex, offsetBy: contentInd)

        let lastSpaceOrNewline = content[..<cursorIndex].rangeOfCharacter(from: .whitespacesAndNewlines, options: .backwards)?.upperBound

        let lastWordStartIndex = lastSpaceOrNewline ?? content.startIndex



        let rangeToDelete = lastWordStartIndex..<cursorIndex

        

        //IMPORTANT!!

        //Wait for changes later

        //remove the word before cursor based on space

        content.removeSubrange(rangeToDelete)

        //Replace the current word with the first word in the predictive text

        // content.insert(contentsOf: predictedWords[0], at: lastWordStartIndex)
        content.insert(contentsOf: predWord, at: lastWordStartIndex)


        // Update contentInd to point to the end of the inserted word

        let deletedWordCount = content.distance(from: lastWordStartIndex, to: cursorIndex)

        contentInd = contentInd - deletedWordCount + predWord.count
        



        print("Replaced word with prediction:", predictedWords[0])
        print("new content: ", content)

    }
    
}

struct CharView_Previews: PreviewProvider {
    static var tempSelect = selectedState(buttonType: ButtonType.cover, buttonId: 0, clickState: 0, isNo: false)
    
    static var previews: some View {
        CharView(state: .constant(2), rowState: .constant(0), charState: .constant(0), content: .constant(""), contentInd: .constant(0), prevState: .constant(2), selectState: .constant(tempSelect), highlightBackspace: .constant(false), queue: .constant([]), value: .constant(0), highlightCursor: .constant(false), playSound: .constant(true), currentCharId: 0, showConfirmation: .constant(true), showSave: .constant(false), customList: .constant([]), nextStateId: .constant(0), prevButtonType: .constant(ButtonType.cover), predictedWords: .constant(["a", "b", "c"]))
    }
}
