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

import Foundation

/// A media type, also known as MIME type and, colloquially as a content type
/// when used in relation to the `Content-Type` HTTP header.
///
/// Media types are composed of the following components:
///
/// - **type** Also termed the *top-level-type*, e.g. `text`.
/// - **subtype** e.g. `plain`.
/// - **facet** An optional period-delimited prefix, e.g. `vnd` that specifies
///   the registration tree for the subtype.
/// - **suffix** An optional structured syntax suffix that specifies the
///   structured of the media type, e.g. `xml` or `json`.
/// - **parameters** A sequence of name/value pairs e.g. `charset=UTF-8`
///   delimited by semi-colons.
///
/// Most of the above components should be interpreted in a case-insensitive
/// manner. The exception to this rule is parameter values, which may be
/// interpreted in a case-sensitive, or case-insensitive manner, depending
/// on the semantics of the property.
///
/// Instances of `MediaType` preserve the case of their input. They also
/// preserve whitespace between components such as parameters. Care should
/// therefore be taken when comparing instances.
///
/// For example, `text/SGML` and `text/sgml` do not compare the same. The
/// `normalized()` method can be used to convert a `MediaType` to a normalized
/// representation that can be used to compare two media types in a case-
/// and whitespace-insensitive manner.
///
/// See The IETF [RFC 6838](https://tools.ietf.org/html/rfc6838) for more
/// information.
public struct MediaType: RawRepresentable {
  public let rawValue: String
  
  /// Initializes the receiver from the given media type string. Returns `nil`
  /// if `rawValue` is not a valid media type.
  ///
  /// - parameters:
  ///   - rawValue: A media type string.
  public init?(rawValue: String) {
    guard rawValue.count > 0 else {
      return nil
    }
    self.rawValue = rawValue
  }
}

// MARK: - Initialization

extension MediaType {
  
  /// Initializes the receiver with the given components.
  ///
  /// - parameters:
  ///   - type: The top-level type.
  ///   - tree: The optional registration *tree*. The tree is ignored if a
  ///     subtype is not specified. Defaults to `standards` if a subtree is
  ///     provided by a tree is not specified.
  ///   - subtype: The optional subtype.
  ///   - suffix: The optional suffix. The suffix is ignored if a subtype is
  ///     not specified.
  ///   - parameters: An optional dictionary of parameters.
  public init(type: Type, tree: Tree? = nil, subtype: String? = nil, suffix: String? = nil, parameters: [String: String]? = nil) {
    var str = ""

    str += type.rawValue.trimmed().lowercased()
    str += subtype.map {
      var sub = "/"
      sub += tree.map { $0 != .standards ? "\($0.rawValue)." : "" } ?? ""
      sub += $0.trimmed()
      sub += (suffix.map { "+\($0.trimmed().lowercased())" } ?? "")
      return sub
    } ?? ""
    str += parameters.map {
      $0.reduce("") { $0 + "; \($1.key.trimmed().lowercased())=\($1.value)" }
    } ?? ""

    self.rawValue = str
  }
}

// MARK: - Hashable

extension MediaType: Hashable {
}

// MARK: - Components

extension MediaType {
  
  /// Parses the media type to return a set of component substrings.
  private var components: (type: Substring, tree: Substring?, subtype: Substring?, suffix: Substring?, parameters: Substring?) {
    get {
      var type = Substring(rawValue)
      var tree: Substring? = nil
      var subtype: Substring? = nil
      var suffix: Substring? = nil
      var parameters: Substring? = nil
      
      if let i = type.firstIndex(of: ";") {
        parameters = type.suffix(from: type.index(after: i))
        type = type.prefix(upTo: i)
      }
      if let i = type.firstIndex(of: "/") {
        subtype = type.suffix(from: type.index(after: i))
        type = type.prefix(upTo: i)
      }
      if let i = subtype?.firstIndex(of: ".") {
        tree = subtype!.prefix(upTo: i)
        subtype = subtype!.suffix(from: subtype!.index(after: i))
      }
      if let i = subtype?.lastIndex(of: "+") {
        suffix = subtype!.suffix(from: subtype!.index(after: i))
        subtype = subtype!.prefix(upTo: i)
      }
      return (type, tree, subtype, suffix, parameters)
    }
  }
}

// MARK: - Computed Properties

extension MediaType {
  
  /// Returns the top-level type.
  public var type: Type {
    get {
      return Type(components.type.trimmed())
    }
  }
  
  /// Returns the subtype's tree, or `nil` if the receiver does not have a
  /// subtype.
  public var tree: Tree? {
    get {
      let comps = components
      if comps.subtype == nil {
        return nil
      }
      if let tree = comps.tree {
        return Tree(rawValue: tree.lowercased())
      } else {
        return .standards
      }
    }
  }
  
  /// Returns the subtype without the facet or suffix, or `nil` if the
  /// media type does not contain a subtype.
  public var subtype: String? {
    get {
      return components.subtype?.trimmed()
    }
  }
  
  /// Returns the subtype's suffix, or `nil` if the media type does not have
  /// a suffix.
  public var suffix: String? {
    get {
      return components.suffix?.trimmed()
    }
  }
}

// MARK: - Parameters

extension MediaType {
  
  /// Calls the given closure for each parameter until the closure returns a
  /// non-nil value.
  ///
  /// - parameters:
  ///   - body: The closure that receivers the name and value of each
  ///     parameter.
  @discardableResult
  private func firstParameter<T>(in params: Substring, where body: (Substring, Substring) -> T?) -> T? {
    for param in params.components(separatedBy: ";") {
      guard let i = param.firstIndex(of: "=") else {
        continue
      }
      let name = param.prefix(upTo: i)
      let value = param.suffix(from: param.index(after: i))
      
      if name.count > 0 && value.count > 0 {
        if let result = body(name, value) {
          return result
        }
      }
    }
    return nil
  }
  
  /// Returns the media type's parameters.
  public var parameters: [String: String] {
    get {
      var params: [String: String] = [:]
      if let parameters = components.parameters {
        firstParameter(in: parameters) { (name: Substring, value: Substring) -> Substring? in
          params[name.trimmed().lowercased()] = value.trimmed()
          return nil
        }
      }
      return params
    }
  }
  
  /// Returns the value of the parameter with the given name, or `nil` if no
  /// such parameter exists. Parameter names are compared in case-insensitive
  /// manner.
  ///
  /// - parameters:
  ///   - name: The name of the parameter.
  public subscript(_ name: String) -> String? {
    get {
      guard let parameters = components.parameters else {
        return nil
      }
      let key = name.lowercased()
      return firstParameter(in: parameters) {
        if key == $0.trimmed().lowercased() {
          return $1.trimmed()
        } else {
          return nil
        }
      }
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Returns a new media type with an additional parameter with the given
  /// name and value, replacing the existing parameter with the same name if
  /// present.
  ///
  /// - parameters:
  ///   - value: The property's value.
  ///   - name: The property's name.
  public func adding(_ value: String, for name: String) -> MediaType {
    let comps = components
    
    let type = Type(String(comps.type))
    let tree = comps.tree.flatMap { Tree(rawValue: String($0)) }
    let subtype = comps.subtype.map { String($0) }
    let suffix = comps.suffix.map { String($0) }
    var params: [String: String] = [:]
    
    if let parameters = components.parameters {
      firstParameter(in: parameters) { (name: Substring, value: Substring) -> Substring? in
        params[name.trimmed().lowercased()] = value.trimmed()
        return nil
      }
    }
    params[name] = value
    
    return MediaType(type: type, tree: tree, subtype: subtype, suffix: suffix, parameters: params)
  }
  
  /// Returns a new media type without the parameter with the given name.
  ///
  /// - parameters:
  ///   - name: The property's name.
  public func removing(_ name: String) -> MediaType {
    let comps = components
    
    let type = Type(String(comps.type))
    let tree = comps.tree.flatMap { Tree(rawValue: String($0)) }
    let subtype = comps.subtype.map { String($0) }
    let suffix = comps.suffix.map { String($0) }
    var params: [String: String] = [:]
    
    if let parameters = components.parameters {
      firstParameter(in: parameters) { (name: Substring, value: Substring) -> Substring? in
        params[name.trimmed().lowercased()] = value.trimmed()
        return nil
      }
    }
    params.removeValue(forKey: name)
    
    return MediaType(type: type, tree: tree, subtype: subtype, suffix: suffix, parameters: params)
  }

  /// Returns a media type without the receiver's parameters.
  public func removingParameters() -> MediaType {
    let comps = components
    
    let type = Type(String(comps.type))
    let tree = comps.tree.flatMap { Tree(rawValue: String($0)) }
    let subtype = comps.subtype.map { String($0) }
    let suffix = comps.suffix.map { String($0) }
    
    return MediaType(type: type, tree: tree, subtype: subtype, suffix: suffix)
  }
}

// MARK: - ExpressibleByStringLiteral

extension MediaType: ExpressibleByStringLiteral {

  /// Creates an instance initialized to the given string value.
  ///
  /// - Parameter value: The value of the new instance.
  public init(stringLiteral value: StaticString) {
    guard let type = Self(rawValue: "\(value)") else {
      preconditionFailure("\(value) is not a valid media type")
    }
    self = type
  }
}
