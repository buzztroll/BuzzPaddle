//
//  StringConsumer.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 9/25/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import Foundation

public protocol EventStringConsumer {
    func incomingString(theValue : String)
}
