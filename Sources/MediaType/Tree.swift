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

public enum Tree {
  case standards
  case vendor
  case personal
  case unregistered
  case other(String)
}

// MARK: - RawRepresentable

extension Tree: RawRepresentable {
  
  /// Returns a string representation for the receiver.
  public var rawValue: String {
    get {
      switch self {
      case .standards:
        return ""
      case .vendor:
        return "vnd"
      case .personal:
        return "prs"
      case .unregistered:
        return "x"
      case .other(let string):
        return string.lowercased()
      }
    }
  }
  
  /// Initializes the receiver with the given string value. Returns `nil` if
  /// the raw value is not a valid top-level type.
  ///
  /// - parameters:
  ///   - rawValue: A top-level type.
  public init?(rawValue: String) {
    let tree = rawValue.lowercased()
    switch tree {
    case "":
      self = .standards
    case "vnd":
      self = .vendor
    case "prs":
      self = .personal
    case "x":
      self = .unregistered
    default:
      self = .other(tree)
    }
  }
}

// MARK: - Initialization

extension Tree {
  
  /// Initializes the receiver with the given string. Raises a precondition
  /// failure if `string` is not a valid tree type. An empty string is
  /// interpreted as the standards tree.
  ///
  /// - parameters:
  ///   - string: A tree string.
  public init(_ string: String) {
    guard let type = Self(rawValue: string) else {
      preconditionFailure("\(string) is not a valid tree")
    }
    self = type
  }
}

// MARK: - Hashable

extension Tree: Hashable {
}

// MARK: - ExpressibleByStringLiteral

extension Tree: ExpressibleByStringLiteral {

  /// Creates an instance initialized to the given string value.
  ///
  /// - Parameter value: The value of the new instance.
  public init(stringLiteral value: StaticString) {
    self.init("\(value)")
  }
}

// MARK: - CustomStringConvertible

extension Tree: CustomStringConvertible {
  
  /// Returns a humanly-readable description of the receiver.
  public var description: String {
    get {
      switch self {
      case .standards:
        return "[standards]"
      default:
        return rawValue
      }
    }
  }
}
