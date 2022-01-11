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
  public enum TextSubtype: String {
    case calendar = "calendar"
    case css = "css"
    case csv = "csv"
    case directory = "directory"
    case dns = "dns"
    case ecmaScript = "ecmascript"
    case html = "html"
    case javascript = "javascript"
    case parameters = "parameters"
    case plain = "plain"
    case richtext = "richtext"
    case rtf = "rtf"
    case sgml = "SGML"
    case strings = "strings"
    case vcard = "vcard"
    case xml = "xml"
  }
}

// MARK: -

extension MediaType {
  
  /// Returns an text media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An text subtype.
  public static func text(_ subtype: TextSubtype) -> MediaType {
    return text(subtype.rawValue)
  }
  
  /// Returns an text media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An text subtype string.
  public static func text(_ subtype: String) -> MediaType {
    return MediaType(type: "text", subtype: subtype)
  }
}

// MARK: -

extension MediaType {
  public enum MarkdownVariant: String {
    case markdown
    case multiMarkdown = "MultiMarkdown"
    case gfm = "GFM"
    case pandoc = "pandoc"
    case pandoc2RFC = "rfc7328"
    case fountain = "Fountain"
    case commonMark = "CommonMark"
    case kramdown = "kramdown-rfc2629"
    case markdownExtra = "Extra"
  }
}

// MARK: -

extension MediaType {

  /// Returns a Markdown media type with the specified variant. See RFC7764 for
  /// details on Markdown variants.
  public static func text(_ variant: MarkdownVariant) -> MediaType {
    switch variant {
    case .markdown:
      return text("markdown")
    default:
      return text("markdown").adding(parameter: "variant", value: variant.rawValue)
    }
  }
}
