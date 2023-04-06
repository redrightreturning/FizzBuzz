//
//  AudioManager.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 10/9/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import AVFoundation

enum Notes {
    
}

class AudioManager : NSObject, UserSettings{
    
    let ARPEGGIO_DELAY = 0.1
    
    let NUMBER_BASE_NOTE : UInt8 = 48
    let BUZZ_BASE_NOTE : UInt8 = 59
    let FIZZ_BASE_NOTE : UInt8 = 56
    let OTHER_BASE_NOTE : UInt8 = 63
    let OFFSET_LIMIT : UInt8 = 100
    
    let MENU_OFFSET : UInt8 = 2
    let SOUND_ON_OFFSET : UInt8 = 6
    
    var incrementUp = true
    let engine = AVAudioEngine()
    var mute = false
    var noteOffset : UInt8 = 0
    let sampler = AVAudioUnitSampler()
    
    override init(){
        
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        do {
            // 1) Configure your audio session category, options, and mode
            try session.setCategory(.ambient, mode: .default, options: [])
            try session.setActive(true)
        } catch let error as NSError {
            print("Unable to activate audio session:  \(error.localizedDescription)")
        }
        
        engine.attach(sampler)
        engine.connect(sampler, to:engine.mainMixerNode, format:engine.mainMixerNode.outputFormat(forBus: 0))
        do {
            if let url = Bundle.main.url(forResource:"FizzBuzz", withExtension:"wav") {
                try sampler.loadAudioFiles(at:[url])
            }
            try engine.start()
        } catch {
            print("Couldn't start engine")
        }
    }
    
    deinit{
        engine.stop()
    }
    
    func incrementOffset(){
        if(incrementUp){
            if(noteOffset < OFFSET_LIMIT){
                noteOffset += 1
            }else{
                incrementUp = false
            }
        }else{
            if(noteOffset > 0){
                noteOffset -= 1
            }else{
                incrementUp = true
            }
        }
    }
    
    func transposeDown(){
        noteOffset -= 1
    }
    
    func resetOffset(){
        noteOffset = 0
    }
    
    func playNumber(){
        if(!isMuted()){
            sampler.startNote((NUMBER_BASE_NOTE + noteOffset), withVelocity: 127, onChannel: 0)
        }
    }
    
    func playFizz(){
        if(!isMuted()){
            sampler.startNote((FIZZ_BASE_NOTE + noteOffset), withVelocity: 127, onChannel: 0)
        }
    }
    func playBuzz(){
        if(!isMuted()){
            sampler.startNote((BUZZ_BASE_NOTE + noteOffset), withVelocity: 127, onChannel: 0)
        }
    }
    
    func playFizzBuzz(){
        playFizz()
        playBuzz()
    }
    
    func playOther(){
        if(!isMuted()){
            sampler.startNote((OTHER_BASE_NOTE + noteOffset), withVelocity: 127, onChannel: 0)
        }
    }
    
    func soundOn(){
        arpeggioUp(offset: SOUND_ON_OFFSET)
    }
    
    func openMenu(){
        arpeggioUp(offset: MENU_OFFSET)
    }
    
    func closeMenu(){
        arpeggioDown(offset: MENU_OFFSET)
    }
    
    func changeSet(){
        arpeggioUp(offset: 0)
    }
    
    func startGame(){
        let notes = [NUMBER_BASE_NOTE, (NUMBER_BASE_NOTE + 12), (NUMBER_BASE_NOTE + 24), (NUMBER_BASE_NOTE + 36)]
        arpeggio(notes: notes, offset: 0)
    }
    
    func gameOver(){
        let notes = [(OTHER_BASE_NOTE + noteOffset), (OTHER_BASE_NOTE + noteOffset - 1), (OTHER_BASE_NOTE + noteOffset - 2), (OTHER_BASE_NOTE + noteOffset - 3), (OTHER_BASE_NOTE + noteOffset - 4)]
        arpeggio(notes: notes, offset: 0)
    }
    
    func arpeggioUp(offset : UInt8){
        let notes = [NUMBER_BASE_NOTE, FIZZ_BASE_NOTE, BUZZ_BASE_NOTE, OTHER_BASE_NOTE]
        arpeggio(notes: notes, offset: offset)
    }
    
    func arpeggioDown(offset : UInt8){
        let notes = [OTHER_BASE_NOTE, BUZZ_BASE_NOTE, FIZZ_BASE_NOTE, NUMBER_BASE_NOTE]
        arpeggio(notes: notes, offset: offset)
    }
    
    func arpeggio(notes : [UInt8], offset : UInt8){
        var notes = notes
        //Add offset to notes
        for (index, _) in notes.enumerated(){
            notes[index] += offset
        }
        
        if(!isMuted()){
            
            DispatchQueue.global().async {[unowned self] in
                self.sampler.startNote(notes[0], withVelocity: 127, onChannel: 0)
                notes.removeFirst()
                playNotes(notes: notes)
            }
        }
        func playNotes(notes : [UInt8]){
            var notes = notes
            if(notes.count > 0){
                DispatchQueue.global().asyncAfter(deadline: .now() + self.ARPEGGIO_DELAY){[unowned self] in
                    
                    self.sampler.startNote(notes[0], withVelocity: 127, onChannel: 0)
                    notes.removeFirst()
                    playNotes(notes: notes)
                }
            }
        }
    }
}
