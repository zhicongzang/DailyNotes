//
//  ZZTagsFieldExtensions.swift
//  DailyNotes
//
//  Created by Zhicong Zang on 9/13/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import Foundation

extension String {
    var md5: String {
        let string = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let stringLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(string!, stringLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        return hash as String
        
    }
}