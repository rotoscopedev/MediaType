//
// MIT License
//
// Copyright (c) 2020 Rotoscope GmbH
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
  public struct ModelSubtype: Subtype {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.ModelSubtype {
  public static let dwf: Self = "vnd.dwf"
  public static let mesh: Self = "mesh"
  public static let mtl: Self = "mtl"
  public static let obj: Self = "obj"
  public static let stl: Self = "stl"
  public static let vrml: Self = "vrml"
  public static let x3dXML: Self = "x3d+xml"
}

// MARK: -

extension MediaType {
  
  /// Returns an model media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An model subtype.
  public static func model(_ subtype: ModelSubtype) -> Self {
    return Self(type: "model", subtype: subtype.rawValue)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `model` top-level type. The media type does not have
  /// a sub-type.
  public static let model = Self(type: .model)
}
