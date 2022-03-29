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
  public enum FontSubtype: String {
    case collection = "collection"
    case otf = "otf"
    case ttf = "ttf"
    case woff = "woff"
    case woff2 = "woff2"
  }
}

// MARK: -

extension MediaType {

  /// Returns an font media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An font subtype.
  public static func font(_ subtype: FontSubtype) -> Self {
    return font(subtype.rawValue)
  }

  /// Returns an font media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An font subtype string.
  public static func font(_ subtype: String) -> Self {
    return Self(type: "font", subtype: subtype)
  }
}
