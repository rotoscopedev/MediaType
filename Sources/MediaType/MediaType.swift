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

import Foundation

/// A media type, also known as MIME type and, colloquially as a content type
/// when used in relation to the `Content-Type` HTTP header.
///
/// Media types are composed of the following components:
///
/// - **type** Also termed the *top-level-type*, e.g. `text`.
/// - **subtype** e.g. `plain`.
/// - **facet** An optional period-delimited prefix, e.g. `vnd` that specifies
///   the registration tree for the subtype.
/// - **suffix** An optional structured syntax suffix that specifies the
///   structured of the media type, e.g. `xml` or `json`.
/// - **parameters** A sequence of name/value pairs e.g. `charset=UTF-8`
///   delimited by semi-colons.
///
/// Most of the above components should be interpreted in a case-insensitive
/// manner. The exception to this rule is parameter values, which may be
/// interpreted in a case-sensitive, or case-insensitive manner, depending
/// on the semantics of the property.
///
/// Instances of `MediaType` preserve the case of their input. They also
/// preserve whitespace between components such as parameters. Care should
/// therefore be taken when comparing instances.
///
/// For example, `text/SGML` and `text/sgml` do not compare the same. The
/// `normalized()` method can be used to convert a `MediaType` to a normalized
/// representation that can be used to compare two media types in a case-
/// and whitespace-insensitive manner.
///
/// See The IETF [RFC 6838](https://tools.ietf.org/html/rfc6838) for more
/// information.
public struct MediaType: RawRepresentable {
  public let rawValue: String
  
  /// Initializes the receiver from the given media type string. Returns `nil`
  /// if `rawValue` is not a valid media type.
  ///
  /// - parameters:
  ///   - rawValue: A media type string.
  public init?(rawValue: String) {
    guard rawValue.count > 0 else {
      return nil
    }
    self.rawValue = rawValue
  }
}

// MARK: -

extension MediaType {

  /// Initializes the receiver with the given raw components.
  init(verbatim type: some StringProtocol, facet: (some StringProtocol)?, subtype: (some StringProtocol)?, suffix: (some StringProtocol)?, parameters: (some StringProtocol)?) {
    var str = ""
    
    str += type
    str += subtype.map {
      var sub = "/"
      sub += facet
        .map {
          "\($0)."
        } ?? ""
      sub += $0
      sub += suffix
        .map {
          "+\($0)"
        } ?? ""
      return sub
    } ?? ""
    str += parameters.map {
      "; \($0)"
    } ?? ""
    
    self.rawValue = str
  }
  
  /// Initializes the receiver with the given components.
  ///
  /// - parameters:
  ///   - type: The top-level type.
  ///   - facet: The optional subtype facet that identifies the registration
  ///     tree. The facet is ignored if a subtype is not specified.
  ///   - subtype: The optional subtype.
  ///   - suffix: The optional suffix. The suffix is ignored if a subtype is
  ///     not specified.
  ///   - parameters: An optional dictionary of parameters. The parameters are
  ///     serialized in alphanumeric order.
  public init(type: TopLevelType, facet: String? = nil, subtype: String? = nil, suffix: String? = nil, parameters: Parameters? = nil) {
    self.init(
      verbatim: type.rawValue.trimmed(),
      facet: facet?.trimmed(),
      subtype: subtype?.trimmed(),
      suffix: suffix?.trimmed(),
      parameters: parameters
        .flatMap {
          Self.format(parameters: $0)
        }
    )
  }
}

// MARK: -

extension MediaType: Hashable {}
extension MediaType: Sendable {}

// MARK: -

extension MediaType: ExpressibleByStringLiteral {

  /// Creates an instance initialized to the given string value.
  ///
  /// - Parameter stringLiteral: A string literal.
  public init(stringLiteral: StaticString) {
    let string = stringLiteral.withUTF8Buffer {
      String(decoding: $0, as: UTF8.self)
    }
    guard let type = Self(rawValue: string) else {
      preconditionFailure("\(string) is not a valid media type.")
    }
    self = type
  }
}

// MARK: -

extension MediaType: Encodable {
  
  /// Encodes this value into the given encoder.
  ///
  /// - parameters:
  ///   - encoder: The encoder to write data to.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }
}

// MARK: -

extension MediaType: Decodable {
  
  /// Creates a new instance by decoding from the given decoder.
  ///
  /// - parameters:
  ///   - decoder: The decoder to read data from.
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.rawValue = try container.decode(String.self)
    
    guard self.rawValue.count > 0 else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Media type may not be empty")
    }
  }
}

// MARK: -

extension MediaType: CustomStringConvertible {
  
  /// Returns a humanly-readable description of the receiver.
  public var description: String {
    get {
      return rawValue
    }
  }
}
