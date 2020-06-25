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

public enum ModelSubtype: String {
  case dwf = "vnd.dwf"
  case mesh = "mesh"
  case mtl = "mtl"
  case obj = "obj"
  case stl = "stl"
  case vrml = "vrml"
  case x3dXML = "x3d+xml"
}

// MARK: -

extension MediaType {
  
  /// Returns an model media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An model subtype.
  public static func model(_ subtype: ModelSubtype) -> MediaType {
    return model(subtype.rawValue)
  }
  
  /// Returns an model media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An model subtype string.
  public static func model(_ subtype: String) -> MediaType {
    return MediaType(type: "model", subtype: subtype)
  }
}
