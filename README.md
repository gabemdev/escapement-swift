# Escapement Swift

[![Build Status](https://travis-ci.org/hodinkee/escapement-swift.svg?branch=master)](https://travis-ci.org/hodinkee/escapement-swift)
[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)


Render `NSAttributedString`s from the JSON structure generated by [escapement-rb](https://github.com/hodinkee/escapement-rb).

## Requirements

|  Xcode  |  Swift  |  iOS  |  tvOS  |
| :-----: | :-----: | :---: | :----: |
| 8.0     | 3.0     | 8.0   | 9.0    |

## Installation

#### Carthage

If you use [Carthage][] to manage your dependencies, add
Escapement to your `Cartfile`:

```
github "hodinkee/escapement-swift" ~> 5.0
```

## Usage

Escapement exposes two core types: `Document` and `Stylesheet`.

`Document`s can be converted from JSON using `Document(json:)` and converted to JSON using `Document.makeJSON()`.

Now you can render an `NSAttributedString` with the following:

```swift
let stylesheet = Styleheet(rules: [
    Styleheet.Rule(selector: "*", attributes: [NSFontAttributeName: Font.tiemposTextRegular(ofSize: 14)])
    Styleheet.Rule(selector: "*", attributes: [NSForegroundColorAttributeName: Color.darkText]),
    Styleheet.Rule(selector: "mark", attributes: [NSBackgroundColorAttributeName: Color.highlight])])
let attributedString = document?.attributedString(stylesheet: stylesheet)
```

A `Stylesheet` allows you to decorate HTML markup with `NSAttributedString` attributes. Any attributes applied to the `*` selector are given to the attributed string upon initialization before other rules are applied. Attributes are computed for a given selector by performing a distinct union of all attributes that match that selector in the stylesheet.

Escapement will render `a`, `strong`, `b`, `em`, `i`, `s`, `del`, and `u` tags by default.

[Carthage]: https://github.com/Carthage/Carthage
