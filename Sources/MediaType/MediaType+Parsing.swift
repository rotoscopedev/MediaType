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
  
  /// Parses the given parameter value. Returns `nil` if `value` is not a valid
  /// parameter value.
  ///
  func parse(value: String) -> String? {

    /// Unescapes quotes in the given string.
    ///
    func unescapeQuotes(in value: String) -> String {
      return value.replacingOccurrences(of: "\\\"", with: "\"")
    }
    
    /// Unquotes the given string, removing double-quote characters from the
    /// start and end of the string.
    ///
    func unquote(_ value: String) -> String {
      return String(
        value
          .dropFirst()
          .dropLast()
      )
    }

    if value.hasPrefix("\""), value.hasSuffix("\"") {
      return unescapeQuotes(in: unquote(value))
    } else {
      return value
    }
  }
  
  /// Parses the given parameters to return a `Parameters` sequence.
  ///
  func parse(parameters: some StringProtocol) -> [Parameter] {
    var output: [Parameter] = []
    
    for param in parameters.components(separatedBy: ";") {
      guard let i = param.firstIndex(of: "=") else {
        continue
      }
      let name = param.prefix(upTo: i)
      let value = param.suffix(from: param.index(after: i))
      
      if name.count > 0 && value.count > 0, let value = parse(value: value.trimmed()) {
        output.append(
          Parameter(name: String(name), value: value)
        )
      }
    }
    return output
  }
  
  /// Parses the media type to return a set of component substrings.
  /// 
  func parse() -> (type: Substring, facet: Substring?, subtype: Substring?, suffix: Substring?, parameters: Substring?) {
    var type = Substring(rawValue)
    var facet: Substring? = nil
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
      facet = subtype!.prefix(upTo: i)
      subtype = subtype!.suffix(from: subtype!.index(after: i))
    }
    if let i = subtype?.lastIndex(of: "+") {
      suffix = subtype!.suffix(from: subtype!.index(after: i))
      subtype = subtype!.prefix(upTo: i)
    }
    return (type, facet, subtype, suffix, parameters)
  }
}
