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
  public struct VideoSubtype: Subtype {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.VideoSubtype {
  public static let avi: Self = "x-msvideo"
  public static let h261: Self = "H261"
  public static let h263: Self = "H263"
  public static let h264: Self = "H264"
  public static let h265: Self = "H265"
  public static let jpeg: Self = "JPEG"
  public static let jpeg2000: Self = "jpeg2000"
  public static let mp4: Self = "mp4"
  public static let mpeg: Self = "mpeg"
  public static let mpeg4Generic: Self = "mpeg4-generic"
  public static let ogg: Self = "ogg"
  public static let quicktime: Self = "quicktime"
  public static let raw: Self = "raw"
  public static let vp8: Self = "VP8"
  public static let webm: Self = "webm"
}

// MARK: -

extension MediaType {
  
  /// Returns a video media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: A video subtype.
  public static func video(_ subtype: VideoSubtype) -> Self {
    return Self(type: "video", subtype: subtype.rawValue)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `video` top-level type. The media type does not have
  /// a sub-type.
  public static let video = Self(type: .video)
}
