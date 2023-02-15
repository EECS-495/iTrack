EECS 495 - iTrack

This application uses eye movements to communicate a message from the user to their smartphone. Eye movements such as up, down, left, right, and blinking will interact with the user interface to create a sequence of characters.


Intended Audience

- People with motor and/or speech disabilities.
- For example, people impacted by ALS or Parkinson's Disease.
- Intended users do not have the option to use text-to-speech or speech-to-text to transfer messages to their smartphone.
- Our design takes away from the precise movements of typing and correct pronunciation associated with speaking.


Alpha Release:

Functional Components:
Character selection 
- A series of eye movements and blinks allows the user to find and select their desired character
- Selected character is highlighted

Character deletion
- User can delete a character on any screen by looking up and blinking

Non-Functional Components:
Efficiency and Accuracy
- Quick typing without compromising accuracy
- Confirm selections with a blink

Able to tolerate imperfect environments
- Shaky camera due to transport, walking, etc.

Most of the logic regarding eye tracking and ARKit Framework configuration can be found in iTrackAlpha/iTrackAlpha/ViewController.swift.