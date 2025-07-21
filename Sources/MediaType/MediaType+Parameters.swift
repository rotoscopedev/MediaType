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
  
  /// A name/value parameter tuple.
  public struct Parameter: Sendable, Equatable {
    public let name: String
    public let value: String
    
    public init(name: String, value: String) {
      self.name = name.trimmed()
      self.value = value.trimmed()
    }
  }
}

// MARK: -

extension MediaType {
  
  /// A collection of parameters.
  public struct Parameters: Sendable, Equatable {
    public typealias Element = Parameter
    
    var elements: [Element]

    /// Initializes the collection with the given elements.
    public init(_ elements: [Element] = []) {
      self.elements = elements
        .map {
          Element(
            name: $0.name.trimmed(),
            value: $0.value.trimmed()
          )
        }
    }

    public static let none = Self()
  }
}

// MARK: -

extension MediaType.Parameters: BidirectionalCollection, RandomAccessCollection {
  public typealias Index = Array<Element>.Index
  
  public var startIndex: Index { return elements.startIndex }
  public var endIndex: Index { return elements.endIndex }
  
  public subscript(position: Index) -> Element { return elements[position] }
  
  public func index(before index: Index) -> Index { return elements.index(before: index) }
  public func index(after index: Index) -> Index { return elements.index(after: index) }
}

// MARK: -

extension MediaType.Parameters: ExpressibleByArrayLiteral {

  /// Creates an instance initialized with the given elements.
  public init(arrayLiteral elements: Element...) {
    self.elements = elements
  }
}

// MARK: -

extension MediaType.Parameters: ExpressibleByDictionaryLiteral {

  /// Creates an instance initialized with the given key-value pairs.
  public init(dictionaryLiteral elements: (String, String)...) {
    self.init(
      elements
        .map {
          Element(name: $0.0, value: $0.1)
        }
    )
  }
}

// MARK: -

extension MediaType.Parameters {
  
  /// Returns the index of the parameter with the given name, or `nil` if no
  /// parameter was found.
  ///
  /// Names are compared in a case-insensitive manner.
  public func index(of name: String) -> Index? {
    let name = name.trimmed()
    
    return elements
      .firstIndex {
        $0.name.caseInsensitiveCompare(name) == .orderedSame
      }
  }

  /// Returns the value of the first parameter with the given name.
  ///
  /// Names are compared in a case-insensitive manner.
  public subscript(_ name: String) -> String? {
    get {
      return elements
        .first {
          name.caseInsensitiveCompare($0.name) == .orderedSame
        }?
        .value
    }
    set {
      if let newValue {
        add(newValue, for: name)
      } else {
        remove(name)
      }
    }
  }
  
  /// Determines whether the collection contains a parameter with the given
  /// name.
  ///
  /// Names are compared in a case-insensitive manner.
  public func contains(_ name: String) -> Bool {
    return index(of: name) != nil
  }
}

// MARK: -

extension MediaType.Parameters {
  
  /// Adds the given parameter to the collection.
  ///
  /// If a parameter with the given name already exists then it is replaced.
  private mutating func add(_ element: Element) {
    if let index = index(of: element.name) {
      elements[index] = element
    } else {
      elements.append(element)
    }
  }
  
  /// Adds the given parameter to the collection.
  ///
  /// If a parameter with the given name already exists then it is replaced.
  private mutating func add(_ value: String, for name: String) {
    add(Element(name: name, value: value))
  }
  
  /// Returns the result of adding the given parameter.
  ///
  /// If a parameter with the given name already exists then it is replaced.
  public func adding(_ element: Element) -> Self {
    var copy = self
    copy.add(element)
    return copy
  }
  
  /// Returns the result of adding a parameter with the given name and value.
  public func adding(_ value: String, for name: String) -> Self {
    return adding(Element(name: name, value: value))
  }
  
  /// Returns the result of adding the given value for the specified key path.
  public func adding<T>(_ value: T, for keyPath: WritableKeyPath<Self, T>) -> Self {
    var copy = self
    copy[keyPath: keyPath] = value
    return copy
  }
}

// MARK: -

extension MediaType.Parameters {
  
  /// Removes the parameter with the given name.
  public mutating func remove(_ name: String) {
    if let index = index(of: name) {
      elements.remove(at: index)
    }
  }
  
  /// Removes all parameters.
  public mutating func removeAll() {
    elements.removeAll()
  }
  
  /// Returns the result of removing the parameter with the given name.
  public func removing(_ name: String) -> Self {
    var copy = self
    copy.remove(name)
    return copy
  }
  
  /// Returns the result of removing the parameter with the given key path.
  public func removing<T>(_ keyPath: WritableKeyPath<Self, T?>) -> Self {
    var copy = self
    copy[keyPath: keyPath] = nil
    return copy
  }
}

// MARK: -

extension MediaType.Parameters: CustomDebugStringConvertible {
  
  /// Returns a humanly-readable description suitable for debugging.
  public var debugDescription: String {
    get {
      return MediaType.format(parameters: elements) ?? ""
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Returns the media type's parameters.
  public var parameters: Parameters {
    get {
      return parse()
        .parameters
        .map {
          Parameters(parse(parameters: $0))
        } ?? .none
    }
    set {
      let comps = parse()
      self = Self(
        verbatim: comps.type,
        facet: comps.facet,
        subtype: comps.subtype,
        suffix: comps.suffix,
        parameters: !newValue.isEmpty ? format(parameters: newValue) : nil
      )
    }
    _modify {
      let comps = parse()
      
      let original: Parameters = comps
        .parameters
        .map {
          Parameters(parse(parameters: $0))
        } ?? .none
      
      var modified = original
      yield &modified
      
      if modified != original {
        self = Self(
          verbatim: comps.type,
          facet: comps.facet,
          subtype: comps.subtype,
          suffix: comps.suffix,
          parameters: !modified.isEmpty ? format(parameters: modified) : nil
        )
      }
    }
  }
}
