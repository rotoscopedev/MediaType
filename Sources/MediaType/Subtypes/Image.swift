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

public enum ImageSubtype: String {
  case bmp = "bmp"
  case gif = "gif"
  case heic = "heic"
  case jpeg = "jpeg"
  case icon = "vnd.microsoft.icon"
  case png = "png"
  case tiff = "tiff"
  case adobePhotoshop = "vnd.adobe.photoshop"
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
