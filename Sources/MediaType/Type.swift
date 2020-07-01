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

public enum Type {
  case application
  case audio
  case example
  case font
  case image
  case message
  case model
  case multipart
  case text
  case video
  case other(String)
}

// MARK: -

extension Type: RawRepresentable {
  
  /// Returns a string representation for the receiver.
  public var rawValue: String {
    get {
      switch self {
      case .application:
        return "application"
      case .audio:
        return "audio"
      case .example:
        return "example"
      case .font:
        return "font"
      case .image:
        return "image"
      case .message:
        return "message"
      case .model:
        return "model"
      case .multipart:
        return "multipart"
      case .text:
        return "text"
      case .video:
        return "video"
      case .other(let string):
        return string
      }
    }
  }
  
  /// Initializes the receiver with the given string value. Returns `nil` if
  /// the raw value is not a valid top-level type.
  ///
  /// - parameters:
  ///   - rawValue: A top-level type.
  public init?(rawValue: String) {
    guard rawValue.count > 0 else {
      return nil
    }
    switch rawValue.lowercased() {
    case "application":
      self = .application
    case "audio":
      self = .audio
    case "example":
      self = .example
    case "font":
      self = .font
    case "image":
      self = .image
    case "message":
      self = .message
    case "model":
      self = .model
    case "multipart":
      self = .multipart
    case "text":
      self = .text
    case "video":
      self = .video
    default:
      self = .other(rawValue.trimmed())
    }
  }
}

// MARK: - Initialization

extension Type {
  
  /// Initializes the receiver with the given string. Raises a precondition
  /// failure if `string` is not a valid top-level type.
  ///
  /// - parameters:
  ///   - string: A top-level type string.
  public init(_ string: String) {
    guard let type = Self(rawValue: string) else {
      preconditionFailure("\(string) is not a valid top-level type")
    }
    self = type
  }
}

// MARK: - Hashable

extension Type: Hashable {
}

// MARK: - ExpressibleByStringLiteral

extension Type: ExpressibleByStringLiteral {

  /// Creates an instance initialized to the given string value.
  ///
  /// - Parameter value: The value of the new instance.
  public init(stringLiteral value: StaticString) {
    self.init("\(value)")
  }
}

// MARK: - CustomStringConvertible

extension Type: CustomStringConvertible {
  
  /// Returns a humanly-readable description of the receiver.
  public var description: String {
    get {
      return rawValue
    }
  }
}
