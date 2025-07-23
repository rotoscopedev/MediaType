//
// MIT License
//
// Copyright (c) 2025 Rotoscope GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

extension MediaType {
  
  /// Returns the top-level type.
  public var type: TopLevelType {
    get {
      return TopLevelType(parse().type.trimmed())
    }
    set {
      let comps = parse()
      
      self = Self(
        verbatim: newValue.rawValue.trimmed(),
        facet: comps.facet,
        subtype: comps.subtype,
        suffix: comps.suffix,
        parameters: comps.parameters
      )
    }
  }
  
  /// Returns the subtype facet that identifies the type's registration tree,
  /// or `nil` if no facet is present. Will also return `nil` if the type does
  /// not have a subtype.
  public var facet: String? {
    get {
      let comps = parse()
      if comps.subtype == nil {
        return nil
      } else {
        return comps.facet?.trimmed()
      }
    }
    set {
      let comps = parse()
      let newValue = newValue?.trimmed() ?? ""
      
      self = Self(
        verbatim: comps.type,
        facet: !newValue.isEmpty ? newValue : nil,
        subtype: comps.subtype,
        suffix: comps.suffix,
        parameters: comps.parameters
      )
    }
  }
  
  /// Returns the subtype's registration tree. Will return `standards` if
  /// no subtype is present.
  public var tree: Tree {
    get {
      guard let facet = self.facet else {
        return .standards
      }
      switch facet.lowercased() {
      case "vnd":
        return .vendor
      case "prs":
        return .personal
      case "x":
        return .unregistered
      default:
        return .other(facet)
      }
    }
  }
  
  /// Returns the subtype without the facet or suffix, or `nil` if the
  /// media type does not contain a subtype.
  public var subtype: String? {
    get {
      return parse().subtype?.trimmed()
    }
    set {
      let comps = parse()
      let newValue = newValue?.trimmed() ?? ""
      
      self = Self(
        verbatim: comps.type,
        facet: comps.facet,
        subtype: !newValue.isEmpty ? newValue : nil,
        suffix: comps.suffix,
        parameters: comps.parameters
      )
    }
  }
  
  /// Returns the subtype's suffix, or `nil` if the media type does not have
  /// a suffix.
  public var suffix: String? {
    get {
      return parse().suffix?.trimmed()
    }
    set {
      let comps = parse()
      let newValue = newValue?.trimmed() ?? ""

      self = Self(
        verbatim: comps.type,
        facet: comps.facet,
        subtype: comps.subtype,
        suffix: !newValue.isEmpty ? newValue : nil,
        parameters: comps.parameters
      )
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Returns the result of applying the transform to the given key path.
  public func map<T>(_ keyPath: WritableKeyPath<Self, T>, _ transform: (T) throws -> T) rethrows -> Self {
    var copy = self
    copy[keyPath: keyPath] = try transform(self[keyPath: keyPath])
    return copy
  }
}

// MARK: -

extension MediaType {
  
  /// Returns the result of setting the value of the given key path with the
  /// the specified value.
  public func replacing<T>(_ keyPath: WritableKeyPath<Self, T>, with value: T) -> Self {
    var copy = self
    copy[keyPath: keyPath] = value
    return copy
  }
}
