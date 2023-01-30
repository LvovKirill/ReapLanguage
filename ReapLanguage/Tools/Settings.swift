//
//  Settings.swift
//  FastEnglish
//
//  Created by Kirill on 27.06.2022.
//

import Foundation
import UIKit

class Settings{
    
    static var numberRepetitions = 10.0
    static var theme = "unspecified"
//    static var lang = "Русский 🇷🇺"
    static var wordInDay = 3
    
    
    static func uploadSettings(){
        
        numberRepetitions = UserDefaults.standard.double(forKey: "numberRepetitions")
//        theme = UserDefaults.standard.string(forKey: "theme")!
        
//        lang = UserDefaults.standard.string(forKey: "lang")!
        wordInDay = UserDefaults.standard.integer(forKey: "wordInDay")
        
    }
    
    

    
}
