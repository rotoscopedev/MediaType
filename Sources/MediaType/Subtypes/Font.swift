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

public enum FontSubtype: String {
  case collection = "collection"
  case otf = "otf"
  case ttf = "ttf"
  case woff = "woff"
  case woff2 = "woff2"
}

// MARK: -

extension MediaType {

  /// Returns an font media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An font subtype.
  public static func font(_ subtype: FontSubtype) -> MediaType {
    return font(subtype.rawValue)
  }

  /// Returns an font media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An font subtype string.
  public static func font(_ subtype: String) -> MediaType {
    return MediaType(type: "font", subtype: subtype)
  }
}
