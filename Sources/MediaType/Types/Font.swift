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

extension MediaType {
  public struct FontSubtype: Subtype {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.FontSubtype {
  public static let collection: Self = "collection"
  public static let otf: Self = "otf"
  public static let sfnt: Self = "sfnt"
  public static let ttf: Self = "ttf"
  public static let woff: Self = "woff"
  public static let woff2: Self = "woff2"
}

// MARK: -

extension MediaType {

  /// Returns an font media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An font subtype.
  public static func font(_ subtype: FontSubtype) -> Self {
    return Self(type: "font", subtype: subtype.rawValue)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `font` top-level type. The media type does not have
  /// a sub-type.
  public static let font = Self(type: .font)
}
