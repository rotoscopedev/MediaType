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

public enum MultipartSubtype: String {
  case digest = "digest"
  case encrypted = "encrypted"
  case formData = "form-data"
  case headerSet = "header-set"
  case mixed = "mixed"
  case multilingual = "multilingual"
  case parallel = "parallel"
  case related = "related"
  case report = "report"
  case signed = "signed"
}

// MARK: -

extension MediaType {
  
  /// Returns an multipart media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An multipart subtype.
  public static func multipart(_ subtype: MultipartSubtype) -> MediaType {
    return multipart(subtype.rawValue)
  }
  
  /// Returns an multipart media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An multipart subtype string.
  public static func multipart(_ subtype: String) -> MediaType {
    return MediaType(type: "multipart", subtype: subtype)
  }
}
