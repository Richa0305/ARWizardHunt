//
//  SpeechRecognizer.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/14/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit
import Speech

class SpeechRecognizer: SFSpeechRecognizer {
    static var recognitionTask: SFSpeechRecognitionTask?
    
    
    static func recordAndRecognizeSpeech(audioEngine:AVAudioEngine,speechRecognizer:SFSpeechRecognizer,request: SFSpeechAudioBufferRecognitionRequest, complition: @escaping (_ output: String) -> Void = { _ in }) {
        var outputStr = ""
        // guard let node = audioEngine.inputNode else { return }
        let node = audioEngine.inputNode
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            //self.sendAlert(message: "There has been an audio engine error.")
            outputStr = "Error : \(error.localizedDescription)"
            complition(outputStr)
            return
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            //self.sendAlert(message: "Speech recognition is not supported for your current locale.")
            outputStr = "Error : Speech recognition is not supported for your current locale."
            complition(outputStr)
            return
        }
        if !myRecognizer.isAvailable {
            //self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            outputStr = "Error : Speech recognition is not currently available. Check back at a later time."
            complition(outputStr)
            return
        }
        recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                //self.detectedTextLabel.text = bestString
               // print("bestString \(bestString)")
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
                outputStr = lastString
                complition(outputStr)
              //  print("lastString \(lastString)")
                
                //self.checkForColorsSaid(resultString: lastString)
            } else if let error = error {
               // self.sendAlert(message: "There has been a speech recognition error.")
                print(error)
                outputStr = "Error : There has been a speech recognition error."
            }
        })
        complition(outputStr)
    }
    static func cancelRecording(audioEngine: AVAudioEngine,  request: SFSpeechAudioBufferRecognitionRequest) {
        audioEngine.stop()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        request.endAudio()
        recognitionTask?.cancel()
    }

}
