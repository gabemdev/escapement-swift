//
//  Paragraph.swift
//  Escapement
//
//  Created by Caleb Davenport on 7/16/15.
//  Copyright (c) 2015 Hodinkee. All rights reserved.
//

import Alexander

// MARK: - Constants

private let BoldTagAttributeName = "com.hodinkee.Escapement.BoldTag"
private let ItalicTagAttributeName = "com.hodinkee.Escapement.ItalicTag"


// MARK: - Types

struct Paragraph {
    var text: String
    var entities: [Entity]
}


// MARK: - Equatable

extension Paragraph: Equatable {}

func ==(lhs: Paragraph, rhs: Paragraph) -> Bool {
    return lhs.text == rhs.text && lhs.entities == rhs.entities
}


// MARK: - DecoderType

struct ParagraphDecoder: DecoderType {
    typealias Value = Paragraph
    static func decode(JSON: Alexander.JSON) -> Value? {
        guard
            let text = JSON["text"]?.stringValue,
            let entities = JSON["entities"]?.decodeArray(EntityDecoder)
        else {
            return nil
        }
        return Paragraph(text: text, entities: entities)
    }
}


// MARK: - EncoderType

struct ParagraphEncoder: EncoderType {
    typealias Value = Paragraph
    static func encode(value: Value) -> JSON {
        return Alexander.JSON(object: [
            "text": value.text,
            "entities": value.entities.map({ EntityEncoder.encode($0).object })
        ])
    }
}


// MARK: - AttributedStringConvertible

extension Paragraph: AttributedStringConvertible {
    func attributedStringWithStylesheet(stylesheet: Stylesheet) -> NSAttributedString {
        let defaultFontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let baseFont = stylesheet["*"][NSFontAttributeName] as? UIFont ?? UIFont(descriptor: defaultFontDescriptor, size: defaultFontDescriptor.pointSize)

        var baseAttributes = stylesheet["*"]
        baseAttributes[BoldTagAttributeName] = false
        baseAttributes[ItalicTagAttributeName] = false
        baseAttributes[NSFontAttributeName] = baseFont

        let string = NSMutableAttributedString(string: text, attributes: baseAttributes)

        for entity in entities {
            let range = entity.NSRange

            string.addAttributes(stylesheet[entity.tag], range: range)

            switch entity.tag {
            case "a":
                if let href = entity.href {
                    string.addAttribute(NSLinkAttributeName, value: href, range: range)
                }
            case "strong", "b":
                string.addAttribute(BoldTagAttributeName, value: true, range: range)
            case "em", "i":
                string.addAttribute(ItalicTagAttributeName, value: true, range: range)
            case "s", "del":
                string.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
            default:
                ()
            }
        }

        let baseFontDescriptor = baseFont.fontDescriptor()
        let fontsWithRanges: [(UIFontDescriptor, NSRange)] = string.attributesWithRanges.map({ attributes, range in
            var fontDescriptor: UIFontDescriptor = baseFontDescriptor

            if attributes[BoldTagAttributeName] as? Bool ?? false {
                fontDescriptor = fontDescriptor.boldFontDescriptor
            }

            if attributes[ItalicTagAttributeName] as? Bool ?? false {
                fontDescriptor = fontDescriptor.italicFontDescriptor
            }

            return (fontDescriptor, range)
        })
        for (font, range) in fontsWithRanges {
            string.addAttribute(NSFontAttributeName, value: UIFont(descriptor: font, size: baseFont.pointSize), range: range)
        }

        return NSAttributedString(attributedString: string)
    }
}
