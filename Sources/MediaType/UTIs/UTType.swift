//
// MIT License
//
// Copyright (c) 2022 Rotoscope GmbH
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

#if canImport(UniformTypeIdentifiers)

import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension UTType {
  
  /// Creates and returns a type given a MIME/media type.
  ///
  /// The media type is normalized before conversion is attempted. If a dynamic
  /// type is returned then the parameters are stripped and the conversion is
  /// retried.
  ///
  /// The character set/encoding is preserved for `text/plain` media types with
  /// a `charset` parameter of `UTF-8`, `UTF-16`, `UTF16LE` and `UTF16BE`, which
  /// map to `public.utf8-plain-text` and `public.utf16-plain-text`.
  public init?(mediaType: MediaType, conformingTo supertype: UTType = .data) {
    let normalized = mediaType.normalized()

    // First, look up the media type as-is, i.e. including parameters. Dynamic
    // types are ignored at this stage.
    if let type = Self(mimeType: normalized.rawValue, conformingTo: supertype), !type.isDynamic {
      self = type
      return
    }
    
    // Second, strip the parameters and re-attempt.
    let stripped = normalized.removingParameters()
    
    guard let type = Self(mimeType: stripped.rawValue, conformingTo: supertype) else {
      return nil
    }

    // Finally, provide special-case mapping for plain text.
    //
    // UTType ignores the character set, returning a dynamic type if a charset
    // is present. Inspect the charset and map to the closest encoding possible.
    //
    // - note:
    //
    //   RFC 2781, sections 4.2 ("Interpreting text labelled as UTF-16LE") and
    //   4.3 ("Interpreting text labelled as UTF-16") specify that a UTF-16
    //   processor must be able to handle text labelled as UTF-16 both with and
    //   without a BOM, meaning we can map any of `UTF-16` (byte-ordering
    //   unknown with a possible BOM, assuming UTF-16BE if not present),
    //   `UTF-16BE` (big-endian with optional BOM) and `UTF-16LE` (little-endian
    //   with optional BOM) to `.utf16PlainText`.
    if type == .plainText, let charset = normalized["charset"]?.uppercased() {
      switch charset {
      case "UTF-8":
        self = .utf8PlainText
      case "UTF-16", "UTF-16BE", "UTF-16LE":
        self = .utf16PlainText
      default:
        self = type
      }
      return
    }
    
    self = type
  }
  
  /// The preferred MIME/media type for this type.
  public var preferredMediaType: MediaType? {
    get {
      return self
        .preferredMIMEType
        .flatMap {
          MediaType(rawValue: $0)
        }
    }
  }
}

#endif
