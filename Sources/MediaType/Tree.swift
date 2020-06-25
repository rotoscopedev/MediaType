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

public enum Tree: Hashable {
  case standards
  case vendor
  case personal
  case unregistered
  case other(String)
}

// MARK: -

extension Tree {
  
  /// Returns the subtype facet for this registration tree. Returns `nil` for
  /// `standards`.
  public var facet: String? {
    get {
      switch self {
      case .standards:
        return nil
      case .vendor:
        return "vnd"
      case .personal:
        return "prs"
      case .unregistered:
        return "x"
      case .other(let facet):
        return facet
      }
    }
  }
}
