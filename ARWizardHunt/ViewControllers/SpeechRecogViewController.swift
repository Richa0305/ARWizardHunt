//
//  SpeechRecogViewController.swift
//  ARWizardHunt
//
//  Created by Srivastava, Richa on 10/15/17.
//  Copyright © 2017 Srivastava, Richa. All rights reserved.
//

import UIKit
protocol SpeechRecogViewControllerDelegate {
    func speechRecognizedWithString(recognizedString:String)
}
class SpeechRecogViewController: UIViewController{

    var slt = Slt()
    var openEarsEventsObserver = OEEventsObserver()
    var fliteController = OEFliteController()
    
    var usingStartingLanguageModel = Bool()
    var startupFailedDueToLackOfPermissions = Bool()
    var restartAttemptsDueToPermissionRequests = Int()
    var pathToFirstDynamicallyGeneratedLanguageModel: String!
    var pathToFirstDynamicallyGeneratedDictionary: String!
    var pathToSecondDynamicallyGeneratedLanguageModel: String!
    var pathToSecondDynamicallyGeneratedDictionary: String!
    var timer: Timer!
    
    var delegate:SpeechRecogViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
       initializeSpeechRecognizer()
       
    }
    
    func initializeSpeechRecognizer(){
        
        //self.openEarsEventsObserver.delegate = self
        self.restartAttemptsDueToPermissionRequests = 0
        self.startupFailedDueToLackOfPermissions = false
        let languageModelGenerator = OELanguageModelGenerator()
     
        let firstLanguageArray = [
                                  "Alohomora",
                                  "Reducto",
                                  "wingardium leviosa",
                                  "crucio",
                                  "Aparecium",
                                  "Oculus Reparo",
                                  "Aguamenti",
                                  "lumos",
                                  "Accio Gold Cup",
                                  "Aparecium"]
        
        let firstVocabularyName = "FirstVocabulary1"
        
         //languageModelGenerator.verboseLanguageModelGenerator = true // Uncomment me for verbose language model generator debug output to either diagnose your issue or provide information relating to language model generation when asking for help at the forums.
         //OELogging.startOpenEarsLogging() // If you encounter any issues, set this to true to get
        
        let firstLanguageModelGenerationError: Error! = languageModelGenerator.generateLanguageModel(from: firstLanguageArray, withFilesNamed: firstVocabularyName, forAcousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"))
        if(firstLanguageModelGenerationError != nil) {
            print("Error while creating initial language model: \(firstLanguageModelGenerationError)")
        } else {
            
            self.pathToFirstDynamicallyGeneratedLanguageModel = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModel(withRequestedName: firstVocabularyName)
            self.pathToFirstDynamicallyGeneratedDictionary = languageModelGenerator.pathToSuccessfullyGeneratedDictionary(withRequestedName: firstVocabularyName)
            self.usingStartingLanguageModel = true
           
        }
    }
    
    func pocketsphinxDidReceiveHypothesis(_ hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        print("Local callback: The received hypothesis is \(hypothesis!) with a score of \(recognitionScore!) and an ID of \(utteranceID!)") // Log it.
        
        //self.heardTextView.text = "Heard: \"\(hypothesis!)\""
        print("You said \(hypothesis!)")
        delegate?.speechRecognizedWithString(recognizedString: hypothesis!)
        // This is how to use an available instance of OEFliteController. We're going to repeat back the command that we heard with the voice we've chosen.
        self.fliteController.say(_:"You said \(hypothesis!)", with:self.slt)
    }
    // An optional delegate method of OEEventsObserver which informs that the interruption to the audio session ended.
    func audioSessionInterruptionDidEnd() {
        print("Local callback:  AudioSession interruption ended.") // Log it.
        // self.statusTextView.text = "Status: AudioSession interruption ended." // Show it in the status box.
        // We're restarting the previously-stopped listening loop.
        if(!OEPocketsphinxController.sharedInstance().isListening){
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: self.pathToFirstDynamicallyGeneratedLanguageModel, dictionaryAtPath: self.pathToFirstDynamicallyGeneratedDictionary, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false)
            
        }
    }
    
    // An optional delegate method of OEEventsObserver which informs that the audio input became unavailable.
    func audioInputDidBecomeUnavailable() {
        print("Local callback:  The audio input has become unavailable") // Log it.
        // self.statusTextView.text = "Status: The audio input has become unavailable" // Show it in the status box.
        
        if(OEPocketsphinxController.sharedInstance().isListening){
            let stopListeningError: Error! = OEPocketsphinxController.sharedInstance().stopListening() // React to it by telling Pocketsphinx to stop listening since there is no available input (but only if we are listening).
            if(stopListeningError != nil) {
                print("Error while stopping listening in audioInputDidBecomeUnavailable: \(stopListeningError)")
            }
        }
        
        // An optional delegate method of OEEventsObserver which informs that the unavailable audio input became available again.
        func audioInputDidBecomeAvailable() {
            print("Local callback: The audio input is available") // Log it.
            //self.statusTextView.text = "Status: The audio input is available" // Show it in the status box.
            if(!OEPocketsphinxController.sharedInstance().isListening) {
                OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: self.pathToFirstDynamicallyGeneratedLanguageModel, dictionaryAtPath: self.pathToFirstDynamicallyGeneratedDictionary, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false) // Start speech recognition, but only if we aren't already listening.
            }
        }
        // An optional delegate method of OEEventsObserver which informs that there was a change to the audio route (e.g. headphones were plugged in or unplugged).
        func audioRouteDidChange(toRoute newRoute: String!) {
            print("Local callback: Audio route change. The new audio route is \(newRoute)") // Log it.
            //self.statusTextView.text = "Status: Audio route change. The new audio route is \(newRoute)"// Show it in the status box.
            let stopListeningError: Error! = OEPocketsphinxController.sharedInstance().stopListening() // React to it by telling Pocketsphinx to stop listening since there is no available input (but only if we are listening).
            if(stopListeningError != nil) {
                print("Error while stopping listening in audioInputDidBecomeAvailable: \(stopListeningError)")
            }
        }
        
        
        
        
        if(!OEPocketsphinxController.sharedInstance().isListening) {
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: self.pathToFirstDynamicallyGeneratedLanguageModel, dictionaryAtPath: self.pathToFirstDynamicallyGeneratedDictionary, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false) // Start speech recognition, but only if we aren't already listening.
        }
    }
    
    // An optional delegate method of OEEventsObserver which informs that the Pocketsphinx recognition loop has entered its actual loop.
    // This might be useful in debugging a conflict between another sound class and Pocketsphinx.
    func pocketsphinxRecognitionLoopDidStart() {
        
        print("Local callback: Pocketsphinx started.") // Log it.
        //self.statusTextView.text = "Status: Pocketsphinx started." // Show it in the status box.
    }
    
    // An optional delegate method of OEEventsObserver which informs that Pocketsphinx is now listening for speech.
    func pocketsphinxDidStartListening() {
        
        print("Local callback: Pocketsphinx is now listening.") // Log it.
        //self.statusTextView.text = "Status: Pocketsphinx is now listening." // Show it in the status box.
        
        //        self.startButton.isHidden = true // React to it with some UI changes.
        //        self.stopButton.isHidden = false
        //        self.suspendListeningButton.isHidden = false
        //        self.resumeListeningButton.isHidden = true
    }
    
    // An optional delegate method of OEEventsObserver which informs that Pocketsphinx detected speech and is starting to process it.
    func pocketsphinxDidDetectSpeech() {
        print("Local callback: Pocketsphinx has detected speech.") // Log it.
        //self.statusTextView.text = "Status: Pocketsphinx has detected speech." // Show it in the status box.
    }
    
    // An optional delegate method of OEEventsObserver which informs that Pocketsphinx detected a second of silence, indicating the end of an utterance.
    // This was added because developers requested being able to time the recognition speed without the speech time. The processing time is the time between
    // this method being called and the hypothesis being returned.
    func pocketsphinxDidDetectFinishedSpeech() {
        print("Local callback: Pocketsphinx has detected a second of silence, concluding an utterance.") // Log it.
        //self.statusTextView.text = "Status: Pocketsphinx has detected finished speech." // Show it in the status box.
    }
    
    
    // An optional delegate method of OEEventsObserver which informs that Pocketsphinx has exited its recognition loop, most
    // likely in response to the OEPocketsphinxController being told to stop listening via the stopListening method.
    func pocketsphinxDidStopListening() {
        print("Local callback: Pocketsphinx has stopped listening.") // Log it.
        //self.statusTextView.text = "Status: Pocketsphinx has stopped listening." // Show it in the status box.
    }
    
    // An optional delegate method of OEEventsObserver which informs that Pocketsphinx is still in its listening loop but it is not
    // Going to react to speech until listening is resumed.  This can happen as a result of Flite speech being
    // in progress on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
    // or as a result of the OEPocketsphinxController being told to suspend recognition via the suspendRecognition method.
    func pocketsphinxDidSuspendRecognition() {
        print("Local callback: Pocketsphinx has suspended recognition.") // Log it.
        //self.statusTextView.text = "Status: Pocketsphinx has suspended recognition." // Show it in the status box.
    }
    
    // An optional delegate method of OEEventsObserver which informs that Pocketsphinx is still in its listening loop and after recognition
    // having been suspended it is now resuming.  This can happen as a result of Flite speech completing
    // on an audio route that doesn't support simultaneous Flite speech and Pocketsphinx recognition,
    // or as a result of the OEPocketsphinxController being told to resume recognition via the resumeRecognition method.
    func pocketsphinxDidResumeRecognition() {
        print("Local callback: Pocketsphinx has resumed recognition.") // Log it.
        //self.statusTextView.text = "Status: Pocketsphinx has resumed recognition." // Show it in the status box.
    }
    
    // An optional delegate method which informs that Pocketsphinx switched over to a new language model at the given URL in the course of
    // recognition. This does not imply that it is a valid file or that recognition will be successful using the file.
    func pocketsphinxDidChangeLanguageModel(toFile newLanguageModelPathAsString: String!, andDictionary newDictionaryPathAsString: String!) {
        
        print("Local callback: Pocketsphinx is now using the following language model: \n\(newLanguageModelPathAsString!) and the following dictionary: \(newDictionaryPathAsString!)")
    }
    
    // An optional delegate method of OEEventsObserver which informs that Flite is speaking, most likely to be useful if debugging a
    // complex interaction between sound classes. You don't have to do anything yourself in order to prevent Pocketsphinx from listening to Flite talk and trying to recognize the speech.
    func fliteDidStartSpeaking() {
        print("Local callback: Flite has started speaking") // Log it.
        //self.statusTextView.text = "Status: Flite has started speaking." // Show it in the status box.
    }
    
    // An optional delegate method of OEEventsObserver which informs that Flite is finished speaking, most likely to be useful if debugging a
    // complex interaction between sound classes.
    func fliteDidFinishSpeaking() {
        print("Local callback: Flite has finished speaking") // Log it.
        //self.statusTextView.text = "Status: Flite has finished speaking." // Show it in the status box.
    }
    
    func pocketSphinxContinuousSetupDidFail(withReason reasonForFailure: String!) { // This can let you know that something went wrong with the recognition loop startup. Turn on [OELogging startOpenEarsLogging] to learn why.
        print("Local callback: Setting up the continuous recognition loop has failed for the reason \(reasonForFailure), please turn on OELogging.startOpenEarsLogging() to learn more.") // Log it.
        // self.statusTextView.text = "Status: Not possible to start recognition loop." // Show it in the status box.
    }
    
    func pocketSphinxContinuousTeardownDidFail(withReason reasonForFailure: String!) { // This can let you know that something went wrong with the recognition loop startup. Turn on [OELogging startOpenEarsLogging] to learn why.
        print("Local callback: Tearing down the continuous recognition loop has failed for the reason %, please turn on [OELogging startOpenEarsLogging] to learn more.", reasonForFailure) // Log it.
        //self.statusTextView.text = "Status: Not possible to cleanly end recognition loop." // Show it in the status box.
    }
    
    func testRecognitionCompleted() { // A test file which was submitted for direct recognition via the audio driver is done.
        print("Local callback: A test file which was submitted for direct recognition via the audio driver is done.") // Log it.
        if(OEPocketsphinxController.sharedInstance().isListening) { // If we're listening, stop listening.
            let stopListeningError: Error! = OEPocketsphinxController.sharedInstance().stopListening()
            if(stopListeningError != nil) {
                print("Error while stopping listening in testRecognitionCompleted: \(stopListeningError)")
            }
        }
        
    }
    /** Pocketsphinx couldn't start because it has no mic permissions (will only be returned on iOS7 or later).*/
    func pocketsphinxFailedNoMicPermissions() {
        print("Local callback: The user has never set mic permissions or denied permission to this app's mic, so listening will not start.")
        self.startupFailedDueToLackOfPermissions = true
        if(OEPocketsphinxController.sharedInstance().isListening){
            let stopListeningError: Error! = OEPocketsphinxController.sharedInstance().stopListening()
            if(stopListeningError != nil) {
                print("Error while stopping listening in pocketsphinxFailedNoMicPermissions: \(stopListeningError). Will try again in 10 seconds.")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            if(!OEPocketsphinxController.sharedInstance().isListening) {
                OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: self.pathToFirstDynamicallyGeneratedLanguageModel, dictionaryAtPath: self.pathToFirstDynamicallyGeneratedDictionary, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false) // Start speech recognition, but only if we aren't already listening.
            }
        })
    }
    
    
    /** The user prompt to get mic permissions, or a check of the mic permissions, has completed with a true or a false result  (will only be returned on iOS7 or later).*/
    
    func micPermissionCheckCompleted(withResult: Bool) {
        if(withResult) {
            
            self.restartAttemptsDueToPermissionRequests += 1
            if(self.restartAttemptsDueToPermissionRequests == 1 && self.startupFailedDueToLackOfPermissions) { // If we get here because there was an attempt to start which failed due to lack of permissions, and now permissions have been requested and they returned true, we restart exactly once with the new permissions.
                
                if(!OEPocketsphinxController.sharedInstance().isListening) {
                    OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: self.pathToFirstDynamicallyGeneratedLanguageModel, dictionaryAtPath: self.pathToFirstDynamicallyGeneratedDictionary, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false) // Start speech recognition, but only if we aren't already listening.
                }
                
                self.startupFailedDueToLackOfPermissions = false
            }
        }
        
    }
    
    
    
    // This is not OpenEars-specific stuff, just some UI behavior
    func suspendListening(){
        OEPocketsphinxController.sharedInstance().suspendRecognition()
    }

    func resumeListening(){
         OEPocketsphinxController.sharedInstance().resumeRecognition()
    }

    func stopListening(){
        if(OEPocketsphinxController.sharedInstance().isListening){
            let stopListeningError: Error! = OEPocketsphinxController.sharedInstance().stopListening()
            if(stopListeningError != nil) {
                print("Error while stopping listening in pocketsphinxFailedNoMicPermissions: \(stopListeningError)")
            }
        }
        
    }

    func startListening(){
        if(!OEPocketsphinxController.sharedInstance().isListening) {
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: self.pathToFirstDynamicallyGeneratedLanguageModel, dictionaryAtPath: self.pathToFirstDynamicallyGeneratedDictionary, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false) // Start speech recognition, but only if we aren't already listening.
        }
        
    }
    @IBAction func startButtonAction() { // This is the action for the button which starts up the recognition loop again if it has been shut down.
        if(!OEPocketsphinxController.sharedInstance().isListening) {
            OEPocketsphinxController.sharedInstance().startListeningWithLanguageModel(atPath: self.pathToFirstDynamicallyGeneratedLanguageModel, dictionaryAtPath: self.pathToFirstDynamicallyGeneratedDictionary, acousticModelAtPath: OEAcousticModel.path(toModel: "AcousticModelEnglish"), languageModelIsJSGF: false) // Start speech recognition, but only if we aren't already listening.
        }
    
    }


}
