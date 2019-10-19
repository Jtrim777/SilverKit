//
//  StringExtension.swift
//  Mer Translator
//
//  Created by Jake Trimble on 7/1/17.
//  Copyright © 2017 Jake Trimble. All rights reserved.
//

import Foundation

infix operator § : MultiplicationPrecedence

/// A collection of helper string manipulation methods
/// - Author: Jake Trimble
/// - Copyright: © 2019 Jake Trimble. All rights reserved.
/// - Date: Created 7/1/19
public extension String {
    
    /// Because nobody likes .count
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i..<(i + 1)]
    }
    
    /// Returns a segment of the string from the given index to the end
    func substring(from: Int) -> String {
        return self[min(from, length) ..< length]
    }
    
    /// Returns a segment of the string from the beginning to the given index
    func substring(to: Int) -> String {
        return self[0 ..< max(0, to)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        
        let t1 = self[start ..< end]
        return String(t1)
    }
    
    /// Splits a string about a regex
    func split (_ reg:String) -> [String]{
        return self.components(separatedBy: reg)
    }
    
    static func § (lhs : String, rhs : String) -> [String] {
        return lhs.split(rhs)
    }
    
    /// Determines whether this String conforms to the given Regular Expression
    func doesMatch(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.count > 0
        } catch let error {
            print(error)
            return false
        }
    }
    
    /// Returns all of the indicies in this string of the specified character
    func indices(of character:String) -> [Int] {
        var out:[Int] = []
        
        for i in 0..<self.count {
            if self[i] == character {
                out.append(i)
            }
        }
        
        return out
    }
    
    var isCapitalized:Bool { return self.capitalized == self }
    
    func formatArguments(_ args: Any...) -> String {
        let copy = self.replacingOccurrences(of: "$$", with: "§")
        
        var compiled = ""
        
        var ind = 0
        while ind < copy.count {
            if copy[ind] == "$" {
                var si = ""
                for ii in ind+1..<copy.count {
                    if Int(copy[ii]) == nil {
                        break
                    } else {
                        si += copy[ii]
                    }
                }
                let argInd = Int(si)!
                
                compiled += "\(args[argInd])"
                ind += si.count + 1
            } else if copy[ind] == "§" {
                compiled += "$"
                ind += 1
            } else {
                compiled += copy[ind]
                ind += 1
            }
        }
        
        return compiled
    }
    
    func asLowerCamelCase() -> String {
        let pts = self.split(" ")
        var cpts : [String] = []
        
        for pt in pts {
            cpts.append(pt.capitalized)
        }
        
        cpts[0] = pts[0].lowercased()
        
        return cpts.joined()
    }
    
    func asUpperCamelCase() -> String {
        let pts = self.split(" ")
        var cpts : [String] = []
        
        for pt in pts {
            cpts.append(pt.capitalized)
        }
        
        return cpts.joined()
    }
    
    func asSnakeCase() -> String {
        let pts = self.split(" ")
        var lpts : [String] = []
        
        for pt in pts {
            lpts.append(pt.lowercased())
        }
        
        return lpts.joined(separator: "_")
    }
}
