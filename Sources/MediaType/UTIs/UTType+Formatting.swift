//
// MIT License
//
// Copyright (c) 2024 Rotoscope GmbH
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

#if canImport(UniformTypeIdentifiers)

import UniformTypeIdentifiers

fileprivate extension String {
  
  /// Capitalizes the string when the string contains no uppercase characters.
  var conditionalCapitalized: Self {
    get {
      let containsUppercase = self
        .first {
          $0.isUppercase
        } != nil
      
      if containsUppercase {
        return self
      } else {
        return capitalized
      }
    }
  }
}

// MARK: -

extension UTType {

  /// Formats a media type as a localized description that is suitable for use
  /// as a generic description of the type, e.g. `"Image"` for image types,
  /// `"Video"` for video types, etc.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public struct GenericFormatStyle: FormatStyle {
    
    /// Returns a description for the given type. Returns `nil` if a description
    /// is not available.
    func description(for type: UTType) -> String? {
      if type.conforms(to: .epub) {
        return String(localized: "Publication", bundle: .module, comment: "Generic description for publication types (i.e. books/magazines/articles).")
      } else if type.conforms(to: .emailMessage) {
        return String(localized: "Email", bundle: .module, comment: "Generic description for email messages.")
      }
      let types: [UTType] = [
        .application,
        .archive,
        .audio,
        .contact,
        .database,
        .font,
        .image,
        .message,
        .movie,
        .presentation,
        .script,
        .sourceCode,
        .plainText,
      ]
      
      for t in types {
        if type.conforms(to: t), let description = t.localizedDescription?.conditionalCapitalized {
          return description
        }
      }
      if type.conforms(to: .content) {
        return String(localized: "Document", bundle: .module, comment: "Generic description for user-viewable content.")
      }
      return nil
    }
    
    /// Formats a value, using this style.
    public func format(_ type: UTType) -> String {
      let description = description(for: type)
      
      if let description {
        return description
      } else {
        return String(localized: "Data", bundle: .module, comment: "Default generic description for UTIs that don't have a more specific description.")
      }
    }
  }
}

// MARK: -

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension FormatStyle where Self == UTType.GenericFormatStyle {
  public static var generic: Self {
    get {
      return Self()
    }
  }
}

// MARK: -

extension UTType {
  
  /// Formats a media type as a localized description that is suitable for use
  /// as a specific description of the type, e.g. `"JPEG image"` or
  /// `"MP4 Video"`.
  ///
  /// If a specific description is not available then a generic description is
  /// used.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public struct SpecificFormatStyle: FormatStyle {
    
    /// Returns a description for the given type. Returns `nil` if a description
    /// is not available.
    func description(for type: UTType) -> String? {
      if let description = type.localizedDescription?.conditionalCapitalized {
        return description
      } else {
        return nil
      }
    }
    
    /// Formats a value, using this style.
    public func format(_ type: UTType) -> String {
      return description(for: type) ?? type.formatted(.generic)
    }
  }
}

// MARK: -

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension FormatStyle where Self == UTType.SpecificFormatStyle {
  public static var specific: Self {
    get {
      return Self()
    }
  }
}

// MARK: -

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension UTType {
  
  /// Formats the receiver using the given style.
  public func formatted<S>(_ style: S) -> S.FormatOutput where S: FormatStyle, S.FormatInput == Self, S.FormatOutput == String {
    return style.format(self)
  }
  
  /// Formats the receiver using the default style.
  public func formatted() -> String {
    return formatted(.specific)
  }
}

#endif
