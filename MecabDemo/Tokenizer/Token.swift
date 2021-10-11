//
//  Token.swift
//  mecab-ios-sample
//
//  Created by Landon Epps on 4/8/19.
//  Copyright © 2019 Landon Epps. All rights reserved.
//

import mecab

/**
 A struct that represents a MeCab node.
 
 `nil` is used instead of "*" (MeCab's convention) to represent a non-exsistent feature
 */
struct Token {
    /// The exact substring for the token from the text (表層形)
    let surface: String
    /// The primary part of speech (品詞)
    let partOfSpeech: String?
    /// An array including the primary part of speech and any subtypes (品詞, 品詞細分類1, ...)
    let partsOfSpeech: [String]
    /// The type of inflection (活用型)
    let inflectionType: String?
    /// The inflection of the word (活用形)
    let inflection: String?
    /// The lemma (語彙素)
    let lemma: String?
    /// The written form (書字形)
    let writtenForm: String?
    /// The pronunciation of the word (発音形)
    let pronunciation: String?
    /// The kana representation of the word (仮名形)
    let kana: String?
    
    init?(with node: mecab_node_t) {
        guard let surface = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: node.surface), length: Int(node.length), encoding: .utf8, freeWhenDone: false),
              let feature = node.feature,
              let features = String(cString: feature, encoding: .utf8)?.components(separatedBy: ",")
        else {
            // If we don't have a surface and feature, we can't create a token.
            return nil
        }
        
        self.surface = surface as String
        
        partOfSpeech = Self.starToNil(features[safe: 0])
        
        var partsOfSpeech = [String]()
        for index in 0...min(3, features.count - 1) {
            if features[index] != "*" {
                partsOfSpeech.append(features[index])
            }
        }
        self.partsOfSpeech = partsOfSpeech
        
        inflectionType = Self.starToNil(features[safe: 4])
        inflection = Self.starToNil(features[safe: 5])
        // ; f[6]:  lForm
        lemma = Self.starToNil(features[safe: 7])
        writtenForm = Self.starToNil(features[safe: 8])
        pronunciation = Self.starToNil(features[safe: 9])
        kana = Self.starToNil(features[safe: 17])
    }

    private static func starToNil(_ string: String?) -> String? {
        return string == "*" ? nil : string
    }
}
