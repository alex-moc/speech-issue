import Foundation
import Speech
import Accelerate
import SwiftUI

public class AzureService {
    var speechSynthesizer: SPXSpeechSynthesizer?
    var audioEngine: AVAudioEngine?

    public init(subscriptionKey: String,
                region: String,
                language: String = "en-US") {
        var speechConfig: SPXSpeechConfiguration?
        do {
            try speechConfig = SPXSpeechConfiguration(subscription: subscriptionKey, region: region)
            speechConfig?.speechRecognitionLanguage = language
            try self.speechSynthesizer = SPXSpeechSynthesizer(speechConfig!)
        } catch {
            print("error \(error) happened")
            speechSynthesizer = nil
        }
    }

    public func synthesize(_ text: String,
                           onComplete: @escaping () -> Void) {
        guard text.count > 0 else {
            return
        }

        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.category != .playback {
            do {
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setActive(false, options: [])
                try audioSession.setCategory(.playback,
                                             mode: .voicePrompt,
                                             options: [.duckOthers, .defaultToSpeaker])
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                // print("AsureService.synthesize audio error: \(error)")
            }
        }

        DispatchQueue.global(qos: .userInitiated).async { [self] in
            print("SYNTHESIZE: \(text)")
            if let result = try? self.speechSynthesizer?.speakText(text) {
                DispatchQueue.main.async {
                    print("result.reason: \(result.reason.rawValue)")
                }
            }
        }
    }

    public func stopSynthesize() {
        do {
            try? self.speechSynthesizer?.stopSpeaking()
            try AVAudioSession.sharedInstance().setActive(false, options: [])
        } catch {
            print("AsureService.stopSynthesize audio error: \(error)")
        }
    }
}
