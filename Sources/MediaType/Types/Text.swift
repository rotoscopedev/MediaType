//
// MIT License
//
// Copyright (c) 2020 Rotoscope GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import IANACharset

extension MediaType {
  public struct TextSubtype: Subtype {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.TextSubtype {
  public static let calendar: Self = "calendar"
  public static let css: Self = "css"
  public static let csv: Self = "csv"
  public static let directory: Self = "directory"
  public static let dns: Self = "dns"
  public static let ecmaScript: Self = "ecmascript"
  public static let html: Self = "html"
  public static let javascript: Self = "javascript"
  public static let markdown: Self = "markdown"
  public static let parameters: Self = "parameters"
  public static let plain: Self = "plain"
  public static let richtext: Self = "richtext"
  public static let rtf: Self = "rtf"
  public static let sgml: Self = "SGML"
  public static let strings: Self = "strings"
  public static let vcard: Self = "vcard"
  public static let xml: Self = "xml"
}

// MARK: -

extension MediaType {
  
  /// Returns an text media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An text subtype.
  public static func text(_ subtype: TextSubtype) -> Self {
    return text(subtype.rawValue)
  }
  
  /// Returns an text media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An text subtype string.
  public static func text(_ subtype: String) -> Self {
    return Self(type: "text", subtype: subtype)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `text` top-level type. The media type does not have
  /// a sub-type.
  public static let text = Self(type: .text)
}

// MARK: -

extension MediaType.Parameter {
  
  /// Returns a parameter with the given `charset` value.
  public static func charset(_ value: IANACharset) -> Self {
    return Self(
      name: "charset",
      value: value.preferredName
    )
  }
}

// MARK: -

extension MediaType.Parameters {

  /// Returns the value of the `charset` parameter, or `nil` if no such
  /// parameter exists. Also returns `nil` if the value could not be mapped to
  /// an `IANACharset` instance.
  public var charset: IANACharset? {
    get {
      return self["charset"]
        .flatMap {
          IANACharset(string: $0)
        }
    }
    set {
      self["charset"] = newValue?.preferredName
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Normalizes the given charset parameter value.
  func normalize(charset: String) -> String {
    if let charset = IANACharset(string: charset) {
      return charset.preferredName
    } else {
      return charset
    }
  }
}
