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
  public enum MultipartSubtype: String, Hashable, Sendable {
    case digest = "digest"
    case encrypted = "encrypted"
    case formData = "form-data"
    case headerSet = "header-set"
    case mixed = "mixed"
    case multilingual = "multilingual"
    case parallel = "parallel"
    case related = "related"
    case report = "report"
    case signed = "signed"
  }
}

// MARK: -

extension MediaType {
  
  /// Returns an multipart media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An multipart subtype.
  public static func multipart(_ subtype: MultipartSubtype) -> Self {
    return multipart(subtype.rawValue)
  }
  
  /// Returns an multipart media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An multipart subtype string.
  public static func multipart(_ subtype: String) -> Self {
    return Self(type: "multipart", subtype: subtype)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `multipart` top-level type. The media type does not
  /// have a sub-type.
  public static let multipart = Self(type: .multipart)
}
