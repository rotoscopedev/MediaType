// --------------------------------------------------------------------------
//
// Copyright (c) Rotoscope GmbH, 2020.
// All Rights Reserved.
//
// This software is provided "as is," without warranty of any kind, express
// or implied. In no event shall the author or contributors be held liable
// for any damages arising in any way from the use of this software.
//
// --------------------------------------------------------------------------

public enum VideoSubtype: String {
  case avi = "x-msvideo"
  case h261 = "H261"
  case h263 = "H263"
  case h264 = "H264"
  case h265 = "H265"
  case jpeg = "JPEG"
  case jpeg2000 = "jpeg2000"
  case mp4 = "mp4"
  case mpeg = "mpeg"
  case mpeg4Generic = "mpeg4-generic"
  case ogg = "ogg"
  case quicktime = "quicktime"
  case raw = "raw"
  case vp8 = "VP8"
}

// MARK: -

extension MediaType {
  
  /// Returns an text media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An text subtype.
  public static func video(_ subtype: VideoSubtype) -> MediaType {
    return video(subtype.rawValue)
  }
  
  /// Returns an text media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An text subtype string.
  public static func video(_ subtype: String) -> MediaType {
    return MediaType(type: "video", subtype: subtype)
  }
}
