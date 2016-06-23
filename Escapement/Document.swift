//
//  Document.swift
//  Escapement
//
//  Created by Caleb Davenport on 7/16/15.
//  Copyright (c) 2015 Hodinkee. All rights reserved.
//

import Alexander

// MARK: - Document

public struct Document {
    var paragraphs: [Paragraph]
}

extension Document {
    public func attributedString(stylesheet stylesheet: Stylesheet) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(string: "")

        for (index, paragraph) in paragraphs.enumerate() {
            if index != 0 {
                mutableAttributedString.appendAttributedString(NSAttributedString(string: "\n"))
            }
            mutableAttributedString.appendAttributedString(paragraph.attributedString(stylesheet: stylesheet))
        }

        return NSAttributedString(attributedString: mutableAttributedString)
    }
}

extension Document: Equatable {}

public func ==(lhs: Document, rhs: Document) -> Bool {
    return lhs.paragraphs == rhs.paragraphs
}


// MARK: - DocumentDecoder

public struct DocumentDecoder: DecoderType {
    public static func decode(JSON: Alexander.JSON) -> Document? {
        guard let paragraphs = JSON.decodeArray(ParagraphDecoder) else {
            return nil
        }
        return Document(paragraphs: paragraphs)
    }
}


// MARK: - DocumentEncoder

public struct DocumentEncoder: EncoderType {
    public static func encode(value: Document) -> AnyObject {
        return ParagraphEncoder.encodeSequence(value.paragraphs)
    }
}
