//
// MIT License
//
// Copyright (c) 2025 Rotoscope GmbH
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
  public enum MarkdownVariant: String, Sendable, CaseIterable {
    case markdown
    case multiMarkdown = "MultiMarkdown"
    case gfm = "GFM"
    case pandoc = "pandoc"
    case pandoc2RFC = "rfc7328"
    case fountain = "Fountain"
    case commonMark = "CommonMark"
    case kramdown = "kramdown-rfc2629"
    case markdownExtra = "Extra"
    
    /// Internal map of case-independent names.
    private static let map: [String: MarkdownVariant] = {
      allCases
        .reduce(into: [:]) {
          $0[$1.rawValue.lowercased()] = $1
        }
    }()
    
    /// Initializes the receiver from the given string.
    public init?(string: String) {
      if let variant = Self.map[string.lowercased()] {
        self = variant
      } else {
        return nil
      }
    }
  }
}

// MARK: -

extension MediaType.Parameter {
  
  /// Returns a parameter with the given Markdown `variant` parameter.
  public static func markdownVariant(_ value: MediaType.MarkdownVariant) -> Self {
    return Self(
      name: "variant",
      value: value.rawValue
    )
  }
}

// MARK: -

extension MediaType.Parameters {
  
  /// Returns the value of the `variant` parameter, or `nil` if no such
  /// parameter exists. Also returns `nil` if the value could not be mapped to
  /// a `MarkdownVariant` instance.
  public var markdownVariant: MediaType.MarkdownVariant? {
    get {
      return self["variant"]
        .flatMap {
          MediaType.MarkdownVariant(string: $0)
        }
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Normalizes the given Markdown `variant` parameter value.
  func normalize(markdownVariant variant: String) -> String {
    if let variant = MarkdownVariant(string: variant) {
      return variant.rawValue
    } else {
      return variant
    }
  }
}
