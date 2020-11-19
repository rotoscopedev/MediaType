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
  public enum ImageSubtype: String {
    case bmp = "bmp"
    case gif = "gif"
    case jpeg = "jpeg"
    case icon = "vnd.microsoft.icon"
    case png = "png"
    case tiff = "tiff"
    case heif = "heif"
    case heifSequence = "heif-sequence"
    case heic = "heic"
    case heicSequence = "heic-sequence"
    case avif = "avif"
    case avifSequence = "avif-sequence"
    case webp = "webp"
    case adobePhotoshop = "vnd.adobe.photoshop"
  }
}

// MARK: -

extension MediaType {
  
  /// Returns an image media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An image subtype.
  public static func image(_ subtype: ImageSubtype) -> MediaType {
    return image(subtype.rawValue)
  }
  
  /// Returns an image media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An image subtype string.
  public static func image(_ subtype: String) -> MediaType {
    return MediaType(type: "image", subtype: subtype)
  }
}
