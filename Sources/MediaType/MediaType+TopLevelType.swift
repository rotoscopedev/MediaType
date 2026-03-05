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
  public struct TopLevelType: RawRepresentable {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.TopLevelType {
  
  /// Initializes the receiver with the given string. Raises a precondition
  /// failure if `string` is not a valid top-level type.
  ///
  /// - parameters:
  ///   - string: A top-level type string.
  ///
  public init(_ string: String) {
    guard let type = Self(rawValue: string) else {
      preconditionFailure("\(string) is not a valid top-level type.")
    }
    self = type
  }
}

// MARK: -

extension MediaType.TopLevelType: Hashable {}
extension MediaType.TopLevelType: Sendable {}

// MARK: -

extension MediaType.TopLevelType: ExpressibleByStringLiteral {

  /// Creates an instance initialized to the given string value.
  ///
  /// - Parameter stringLiteral: A string literal.
  ///
  public init(stringLiteral: StaticString) {
    let string = stringLiteral.withUTF8Buffer {
      String(decoding: $0, as: UTF8.self)
    }
    self.init(string)
  }
}

// MARK: -

extension MediaType.TopLevelType: CustomStringConvertible {
  
  /// Returns a humanly-readable description of the receiver.
  /// 
  public var description: String {
    get {
      return rawValue
    }
  }
}

// MARK: -

extension MediaType.TopLevelType {
  public static let application: Self = "application"
  public static let audio: Self = "audio"
  public static let example: Self = "example"
  public static let font: Self = "font"
  public static let haptics: Self = "haptics"
  public static let image: Self = "image"
  public static let message: Self = "message"
  public static let model: Self = "model"
  public static let multipart: Self = "multipart"
  public static let text: Self = "text"
  public static let video: Self = "video"
}
