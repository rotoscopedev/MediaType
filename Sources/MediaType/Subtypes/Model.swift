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
  public enum ModelSubtype: String {
    case dwf = "vnd.dwf"
    case mesh = "mesh"
    case mtl = "mtl"
    case obj = "obj"
    case stl = "stl"
    case vrml = "vrml"
    case x3dXML = "x3d+xml"
  }
}

// MARK: -

extension MediaType {
  
  /// Returns an model media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An model subtype.
  public static func model(_ subtype: ModelSubtype) -> Self {
    return model(subtype.rawValue)
  }
  
  /// Returns an model media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An model subtype string.
  public static func model(_ subtype: String) -> Self {
    return Self(type: "model", subtype: subtype)
  }
}
