// --------------------------------------------------------------------------
//
// Copyright (c) Rotoscope GmbH, 2025.
// All Rights Reserved.
//
// This software is provided "as is," without warranty of any kind, express
// or implied. In no event shall the author or contributors be held liable
// for any damages arising in any way from the use of this software.
//
// --------------------------------------------------------------------------

extension MediaType.Parameter {
  
  /// Returns a `codecs` parameter with the given codec names.
  public static func codecs(_ value: [String]) -> Self {
    return Self(
      name: "codecs",
      value: value
          .map {
            $0.trimmed()
          }
          .joined(separator: ", ")
    )
  }
  
  /// Returns a `codecs` parameter with the given codec names.
  public static func codecs(_ first: String, _ rest: String...) -> Self {
    return codecs([ first ] + rest)
  }
}

// MARK: -

extension MediaType.Parameters {
  
  /// Returns the value of an audio or video type's `codecs` parameter.
  public var codecs: [String]? {
    get {
      return self["codecs"]
        .map { $0
          .components(separatedBy: ",")
          .map {
            $0.trimmed()
          }
        }
    }
    set {
      self["codecs"] = newValue
        .map { $0
          .map {
            $0.trimmed()
          }
          .joined(separator: ", ")
        }
    }
  }
}
