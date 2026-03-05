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
  public struct Tree: Sendable, Hashable {
    public let facet: String?
    
    /// Initializes the receiver with the given raw value.
    ///
    /// - parameters:
    ///   - facet: The tree's facet. Specify `nil` for the standards tree.
    ///
    /// - note: An empty string will be interpreted as equivalent to `nil`,
    ///   resulting in a tree with a `nil` `facet`.
    ///
    public init(facet: String?) {
      if let facet = facet?.trimmed() {
        self.facet = !facet.isEmpty ? facet : nil
      } else {
        self.facet = nil
      }
    }
  }
}

// MARK: -

extension MediaType.Tree: ExpressibleByStringLiteral {

  /// Creates an instance initialized to the given string value.
  ///
  /// - Parameter stringLiteral: A string literal.
  /// 
  public init(stringLiteral: StaticString) {
    let string = stringLiteral.withUTF8Buffer {
      String(decoding: $0, as: UTF8.self)
    }
    self.init(facet: string)
  }
}

// MARK: -

extension MediaType.Tree {
  public static let standards: Self = ""
  public static let vendor: Self = "vnd"
  public static let personal: Self = "prs"
  public static let unregistered: Self = "x"
}
