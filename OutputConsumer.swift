//
//  OutputConsumer.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/26/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation

protocol OutputConsumer {
    func incomingString(theOutput : String)
    func longForm() -> Bool
}
