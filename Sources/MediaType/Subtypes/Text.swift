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

public enum TextSubtype: String {
  case calendar = "calendar"
  case css = "css"
  case csv = "csv"
  case directory = "directory"
  case dns = "dns"
  case ecmaScript = "ecmascript"
  case html = "html"
  case javascript = "javascript"
  case markdown = "markdown"
  case parameters = "parameters"
  case plain = "plain"
  case richtext = "richtext"
  case rtf = "rtf"
  case sgml = "SGML"
  case strings = "strings"
  case vcard = "vcard"
  case xml = "xml"
}

// MARK: -

extension MediaType {
  
  /// Returns an text media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An text subtype.
  public static func text(_ subtype: TextSubtype) -> MediaType {
    return text(subtype.rawValue)
  }
  
  /// Returns an text media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An text subtype string.
  public static func text(_ subtype: String) -> MediaType {
    return MediaType(type: "text", subtype: subtype)
  }
}
