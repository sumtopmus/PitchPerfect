//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Oleksandr Iaroshenko on 04.06.15.
//  Copyright (c) 2015 Oleksandr Iaroshenko. All rights reserved.
//

import Foundation

struct RecordedAudio {

    var title: String!
    var filePathURL: NSURL!

    init(title: String!, filePathURL: NSURL) {
        self.title = title
        self.filePathURL = filePathURL
    }
}