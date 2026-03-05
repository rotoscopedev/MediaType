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
  public struct MultipartSubtype: Subtype {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.MultipartSubtype {
  public static let digest: Self = "digest"
  public static let encrypted: Self = "encrypted"
  public static let formData: Self = "form-data"
  public static let headerSet: Self = "header-set"
  public static let mixed: Self = "mixed"
  public static let multilingual: Self = "multilingual"
  public static let parallel: Self = "parallel"
  public static let related: Self = "related"
  public static let report: Self = "report"
  public static let signed: Self = "signed"
}

// MARK: -

extension MediaType {
  
  /// Returns an multipart media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An multipart subtype.
  ///
  public static func multipart(_ subtype: MultipartSubtype) -> Self {
    return Self(type: "multipart", subtype: subtype.rawValue)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `multipart` top-level type. The media type does not
  /// have a sub-type.
  /// 
  public static let multipart = Self(type: .multipart)
}
