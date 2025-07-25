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
  public struct ImageSubtype: Subtype {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.ImageSubtype {
  public static let bmp: Self = "bmp"
  public static let gif: Self = "gif"
  public static let jpeg: Self = "jpeg"
  public static let icon: Self = "vnd.microsoft.icon"
  public static let png: Self = "png"
  public static let tiff: Self = "tiff"
  public static let heif: Self = "heif"
  public static let heifSequence: Self = "heif-sequence"
  public static let heic: Self = "heic"
  public static let heicSequence: Self = "heic-sequence"
  public static let avif: Self = "avif"
  public static let avifSequence: Self = "avif-sequence"
  public static let webp: Self = "webp"
  public static let adobePhotoshop: Self = "vnd.adobe.photoshop"
  public static let svg: Self = "svg+xml"
}

// MARK: -

extension MediaType {
  
  /// Returns an image media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An image subtype.
  public static func image(_ subtype: ImageSubtype) -> Self {
    return image(subtype.rawValue)
  }
  
  /// Returns an image media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An image subtype string.
  public static func image(_ subtype: String) -> Self {
    return Self(type: "image", subtype: subtype)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `image` top-level type. The media type does not have
  /// a sub-type.
  public static let image = Self(type: .image)
}
