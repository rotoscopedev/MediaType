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
  
  /// Normalizes the value of the given parameter.
  ///
  private func normalize(value: String, for name: String, type: (type: (some StringProtocol)?, facet: (some StringProtocol)?, subtype: (some StringProtocol)?, suffix: (some StringProtocol)?)) -> String {
    switch (type.type, type.facet, type.subtype, type.suffix, name) {
    case ("text", nil, _, _, "charset"):
      return normalize(charset: value)
    case ("text", nil, "markdown", _, "variant"):
      return normalize(markdownVariant: value)
    default:
      return value
    }
  }
  
  /// Returns a normalized version of the receiver, which can be used to
  /// compare media types regardless of casing and whitespace.
  ///
  /// The following transformations are applied during transformation:
  ///
  /// - The type is converted to lower case.
  /// - The subtype, including facet and suffix are converted to lower case.
  /// - The names of parameters are converted to lowercase.
  /// - Whitespace is normalized.
  /// - The order of parameters is normalized to being alphabetical sorted by
  ///   name.
  /// - Trailing delimiters are removed.
  ///
  /// e.g.
  ///
  /// ```
  /// text/SGML; CharSet = UTF-8;
  /// ```
  ///
  /// is normalized to
  ///
  /// ```
  /// text/sgml; charset=UTF-8
  /// ```
  /// 
  public func normalized() -> MediaType {
    let comps = parse()
    let parameters = comps.parameters
      .map {
        parse(parameters: $0)
          .map {
            Parameter(
              name: $0.name.lowercased(),
              value: normalize(
                value: $0.value,
                for: $0.name.lowercased(),
                type: (comps.type, facet, subtype, suffix)
              )
            )
          }
          .reduce(into: [:]) {
            if $0[$1.name] == nil {
              $0[$1.name] = $1.value
            }
          }
          .map {
            Parameter(name: $0.key, value: $0.value)
          }
          .sorted {
            $0.name < $1.name
          }
      }
    return Self(
      verbatim: comps.type.trimmed().lowercased(),
      facet: comps.facet?.trimmed().lowercased(),
      subtype: comps.subtype?.trimmed().lowercased(),
      suffix: comps.suffix?.trimmed().lowercased(),
      parameters: parameters
        .flatMap {
          format(parameters: $0)
        }
    )
  }
}
