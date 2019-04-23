//
//  AppBeautifier.swift
//  AppBeautifier
//
//  Created by Pramod Kumar on 06/08/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices
import SafariServices

//MARK:**************************************
//MARK:******* Beautification Methods *******
//MARK:**************************************

///This class allow you to beautify you applcation or increase user experience on you app.
class AppBeautifier {
    
    //MARK:- Private Properties
    //MARK:-
    private var repeatCount: Float = 1.0
    private var radius: CGFloat = 50.0
    private var color: UIColor = UIColor.blue
    private var animationDuration: TimeInterval = 0.5
    private var audioSession = AVAudioSession.sharedInstance()
    
    //MARK:- Shared Instance
    //MARK:-
    static let shared = AppBeautifier()

    //MARK:- Private Methods
    //MARK:-
    private init() {
    }
    
    func printlnDebug <T> (_ object: T, lineNo: Int = #line, fileName: String = #file) {
        print("\(object) at line \(lineNo) in file \(fileName)")
    }
    
    //MARK:- Public Methods
    //MARK:- Enable Touch Animator
    //MARK:-
    ///Method used to show touch animation on view
    func enableTouchAnimator(view: UIView, repeatCount: Float = 1.0, radius: CGFloat = 50.0, color: UIColor = UIColor.blue, animationDuration: TimeInterval = 0.5) {
        self.repeatCount = repeatCount
        self.radius = radius
        self.color = color
        self.animationDuration = animationDuration
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animatorTouchHandler(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func animatorTouchHandler(_ sender:UITapGestureRecognizer) {
        if let touchInView = sender.view {
            let touchedPoint = sender.location(in: touchInView)
            let pulseAnim = PKPulseAnimation(repeatCount: self.repeatCount, radius: self.radius, position: touchedPoint, color: self.color, animationDuration: self.animationDuration)
            touchInView.layer.insertSublayer(pulseAnim, below: touchInView.layer)
        }
    }
    
    //MARK:- Vibrate Device
    //MARK:-
    ///Method used to vibrate the device
    func vibrateDevice() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}


//MARK:- Extention For String
//MARK:-
extension String {
    
    //MARK:- Say Text Message
    //MARK:-
    ///Method used to speak a text through the speaker.
    func sayIt() {
        do {
            let audioSession = AVAudioSession.sharedInstance()

            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try audioSession.setActive(true)
            let synth = AVSpeechSynthesizer()
            if let currentChannels = audioSession.currentRoute.outputs.first?.channels {
                synth.outputChannels = currentChannels
            }
            let myUtterance = AVSpeechUtterance(string: self)
            synth.speak(myUtterance)
            
        } catch {
            AppBeautifier.shared.printlnDebug(error)
        }
    }
}

//MARK:- Extention For UIView
//MARK:-
extension UIView {
    
    //MARK:- Shake View
    //MARK:-
    ///Method used to shake a UIView
    func shakeMe() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20.0, 20.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        self.layer.add(animation, forKey: "shake")
    }
}

//MARK:- Extention For UITableView
//MARK:-
extension UITableView {
    
    //MARK:- Animate Table Data
    //MARK:-
    ///Method used to load data of table view with animation
    func reloadWithEaseInAnimation() {
        
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.5
        transition.subtype = CATransitionSubtype.fromTop
        self.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        // Update your data source here
        self.reloadData()
    }
}
