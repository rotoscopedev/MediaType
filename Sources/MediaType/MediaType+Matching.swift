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
  
  /// Determines whether the receiver matches the given template type.
  ///
  /// The template's `type`, `subtype`, `suffix` and `parameters` are compared
  /// against the receiver's. If the receiver is missing a component or the
  /// value of that component differs from the template's then the method
  /// returns `false`. Components missing from the template are not compared.
  ///
  /// For example, `text/plain; charset=UTF-8` will match `text`, `text/plain`
  /// and `text/plain; charset=UTF-8` but not `text/html` or
  /// `text/plain; charset=UTF-16`. Similarly, `application/vcard+json` will
  /// match `application/vcard` but not `application/sql`.
  ///
  /// Both the receiver and the template are normalized before matching is
  /// attempted.
  ///
  public func matches(_ template: MediaType) -> Bool {
    if self == template {
      return true
    }
    let t1 = self.normalized()
    let t2 = template.normalized()
    
    let c1 = t1.parse()
    let c2 = t2.parse()
    
    guard c1.type == c2.type else { return false }
    guard c1.facet == c2.facet else { return false }
    
    if let subtype = c2.subtype {
      guard c1.subtype == subtype else { return false }
    }
    if let suffix = c2.suffix {
      guard c1.suffix == suffix else { return false }
    }
    var match = true
    
    let p1 = t1.parameters
    let p2 = t2.parameters
    
    p2.forEach {
      if match {
        match = p1[$0.name] == $0.value
      }
    }
    return match
  }
}

// MARK: -

infix operator ~= : ComparisonPrecedence

// MARK: -

extension MediaType {
  
  /// Returns the result of calling `matches(_)` on the left-hand size, passing
  /// in the right-hand side as the template media type to match against.
  /// 
  public static func ~= (lhs: Self, rhs: Self) -> Bool {
    return lhs.matches(rhs)
  }
}
