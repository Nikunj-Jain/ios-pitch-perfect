//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Nikunj Jain on 06/02/16.
//  Copyright © 2016 Nikunj Jain. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    private var filePathURL: NSURL!
    private var title: String!
    
    init(fileURL: NSURL!, audioTitle: String!) {
        
        filePathURL = fileURL
        title = audioTitle
        
    }
    
    func getfilePathURL() -> NSURL! {
        
        return filePathURL
        
    }
    
    func getTitle() -> String! {
        
        return title
        
    }
}
