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

public enum MessageSubtype: String {
  case http = "http"
  case shttp = "s-http"
}

// MARK: -

extension MediaType {
  
  /// Returns an message media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An message subtype.
  public static func message(_ subtype: MessageSubtype) -> MediaType {
    return message(subtype.rawValue)
  }
  
  /// Returns an message media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An message subtype string.
  public static func message(_ subtype: String) -> MediaType {
    return MediaType(type: "message", subtype: subtype)
  }
}
