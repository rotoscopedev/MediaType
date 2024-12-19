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
  
  /// Creates and returns a type that represents the given top-level MIME/media
  /// type. An
  ///
  /// Top-level types for which no clear mapping exists are mapped to the
  /// closest relevant UTI. For example, `application` maps to `content`. Non-
  /// document oriented types for which no clear mapping exists are mapped to
  /// `data`.
  init(_ topLevelType: MediaType.TopLevelType) {
    self = switch topLevelType {
    case .application:    .data
    case .audio:          .audio
    case .example:        .data
    case .font:           .font
    case .haptics:        .data
    case .image:          .image
    case .message:        .message
    case .model:          .content
    case .multipart:      .compositeContent
    case .text:           .text
    case .video:          .movie
    case .other:          .data
    }
  }

  /// Creates and returns a type given a MIME/media type.
  ///
  /// If no mapping exists for `mediaType` then a dynamic type will be produced
  /// that conforms to `supertype`. If no supertype is specified then the
  /// supertype is derived from the top-level type of the specified `mediaType`.
  /// The returned dynamic type will use `mediaType` as its preferred MIME type
  /// but will not have a preferred file extension.
  ///
  /// The media type is normalized before conversion is attempted. If a dynamic
  /// type is returned then the parameters are stripped and the conversion is
  /// retried.
  ///
  /// The character set/encoding is preserved for `text/plain` media types with
  /// a `charset` parameter of `UTF-8`, `UTF-16`, `UTF16LE` and `UTF16BE`, which
  /// map to `public.utf8-plain-text` and `public.utf16-plain-text`.
  ///
  /// Top-level only media types (e.g. `text` or `image`) are mapped to their
  /// UTI equivalents where possible (e.g. `public.text` and `public.image`).
  /// Mappings are not available for some top-level types (e.g. `application`),
  /// which map to `public.data`. Types mapped from a top-level type will not
  /// have a preferred MIME type or file extension.
  ///
  /// - note: The `video` top-level type maps to `public.movie` rather than
  ///   `public.video` as `video` subtypes can generally contain audio as well
  ///   as video tracks.
  public init(mediaType: MediaType, conformingTo supertype: UTType? = nil) {
    let normalized = mediaType.normalized()

    // First, look up the media type as-is, i.e. including parameters. Dynamic
    // types are ignored at this stage.
    if let type = Self(mimeType: normalized.rawValue, conformingTo: supertype ?? Self(normalized.type)), !type.isDynamic {
      self = type
      return
    }
    
    // Second, strip the parameters and re-attempt.
    let stripped = normalized.removingParameters()

    guard let type = Self(mimeType: stripped.rawValue, conformingTo: supertype ?? Self(stripped.type)) else {
      self = Self(stripped.type)
      return
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
    if type == .plainText, let charset = normalized.charset {
      switch charset {
      case .utf8:
        self = .utf8PlainText
      case .utf16, .utf16BE, .utf16LE:
        self = .utf16PlainText
      default:
        self = type
      }
      return
    }
    
    self = type
  }
  
  /// The preferred MIME/media type for this type. The media type is normalized
  /// before being returned.
  public var preferredMediaType: MediaType? {
    get {
      return self
        .preferredMIMEType
        .flatMap {
          MediaType(rawValue: $0)
        }
        .map {
          $0.normalized()
        }
    }
  }
}

#endif
