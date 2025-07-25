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
  public struct MarkdownVariant: Sendable, Hashable, RawRepresentable, ExpressibleByStringLiteral, CustomDebugStringConvertible {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
    
    /// Creates an instance initialized to the given string value.
    ///
    /// - Parameter stringLiteral: A string literal.
    public init(stringLiteral: StaticString) {
      let string = stringLiteral.withUTF8Buffer {
        String(decoding: $0, as: UTF8.self)
      }
      guard let type = Self(rawValue: string) else {
        preconditionFailure("\(string) is not a valid markdown variant.")
      }
      self = type
    }

    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
      get {
        return rawValue
      }
    }
  }
}

// MARK: -

extension MediaType.MarkdownVariant {
  public static let markdown: Self = "markdown"
  public static let multiMarkdown: Self = "MultiMarkdown"
  public static let gfm: Self = "GFM"
  public static let pandoc: Self = "pandoc"
  public static let pandoc2RFC: Self = "rfc7328"
  public static let fountain: Self = "Fountain"
  public static let commonMark: Self = "CommonMark"
  public static let kramdown: Self = "kramdown-rfc2629"
  public static let markdownExtra: Self = "Extra"
}

// MARK: -

extension MediaType.MarkdownVariant {
  fileprivate static let lowercase: [String: Self] = {
    let variants: [Self] = [
      .markdown,
      .multiMarkdown,
      .gfm,
      .pandoc,
      .pandoc2RFC,
      .fountain,
      .commonMark,
      .kramdown,
      .markdownExtra,
    ]
    return variants
      .reduce(into: [:]) {
        $0[$1.rawValue.lowercased()] = $1
      }
  }()
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
          MediaType.MarkdownVariant(rawValue: $0)
        }
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Normalizes the given Markdown `variant` parameter value.
  func normalize(markdownVariant variant: String) -> String {
    if let variant = MarkdownVariant.lowercase[variant.lowercased()] {
      return variant.rawValue
    } else {
      return variant
    }
  }
}
