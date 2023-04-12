EECS 495 - iTrack

This application uses eye movements to communicate a message from the user to their smartphone. Eye movements such as up, down, left, right, and blinking will interact with the user interface to create a sequence of characters.

Requirements:

    Software
        - iOS 11.0+
        - iPadOS 11.0+
        - Mac Catalyst 14.0+

    Hardware
        - iPhone 6s or newer
        - iPad 2017 or newer

Usage:

    - Open the application. Note that new user need to grant the application access to use the front-facing camera.
    - The top bar indicates the things are typed. The top bar will be blank when the application is initially opened.
    - To type new characters, first select either symbols (left), uppercase letters (up), numbers (right), or lowercase letters (down) from the character sets.
    - When select the domain, blink to select, and blink again to confirm.
    - Note that there is a blink delay to prevent unwanted behavior.

Intended Audience:

    - People with motor and/or speech disabilities.
    - For example, people impacted by ALS or Parkinson's Disease.
    - Intended users do not have the option to use text-to-speech or speech-to-text to transfer messages to their smartphone.
    - Our design takes away from the precise movements of typing and correct pronunciation associated with speaking.

Alpha Release:

    Functional Components:

        Character selection:
        - A series of eye movements and blinks allows the user to find and select their desired character
        - Selected character is highlighted

        Character deletion:
        - User can delete a character on any screen by looking up and blinking

    Non-Functional Components:

        Efficiency and Accuracy:
        - Quick typing without compromising accuracy
        - Confirm selections with a blink

        Features that can tolerate imperfect environments:
        - Shaky camera due to transport, walking, etc.
        
Beta Release

    New Features:
        
        Cursor Adjustments:
        - Looking left from the backspace button will highlight the cursor
        - Once the cursor is highlighted, the user can look left or right to shift it's position within their message
        - Looking down from any point in the message will exit the cursor-editing mode
        
        Settings Screen:
        - Blinking while the gear icon in the bottom right of the home screen will open the settings screen
        - The user can currently only customize the blink delay, the gaze delay, the sound that plays after actions, and the presence of the confirmation             screen
        - In settings, blinking while a toggle is highlighted will flip the toggle
        - In settings, blinking while one of the help buttons is highlighted will make a brief explination of the respective setting appear
        - Looking left from any of the toggles will take the user back to the home screen
        
        General Tutorial:
        - After five seconds without navigating away from the home screen, a help button will appear in the bottom left of the home screen
        - Looking left from the settings button will highlight the help button
        - Blinking while on the help button will open the general tutorial that explains how to navigate buttons, "click" buttons, and how to go to the               previous page
        - Looking left will bring the user back to the home screen
        
        Custom Phrases:
        - Users can create and load custom phrases that they use often into their messages without having to type them character by character every time
        - In the custom phrases screen, users will see a list of their previously saved phrases that they can immediately insert into the text field
        - Users can create a new custom phrase with the add button at the bottom, where they will be given the normal interface for typing with a save               button at the top for when they are ready to save the contents of the text field

Most of the logic regarding eye tracking and ARKit Framework configuration can be found in the "iTrackAlpha/iTrackAlpha/ViewController.swift" file.
