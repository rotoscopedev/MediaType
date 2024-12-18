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

extension MediaType {

  /// Formats a media type as a localized description that is suitable for use
  /// as a generic description of the type, e.g. `"Image"` for image types,
  /// `"Video"` for video types, etc.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public struct GenericFormatStyle: FormatStyle {
    enum Context: Hashable, Codable {
      case file
    }
    let context: Context?
    
    /// Formats a value, using this style.
    public func format(_ type: MediaType) -> String {
      if let type = UTType(mediaType: type) {

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
      }
      
      if context == .file {
        return String(localized: "File", bundle: .module, comment: "Default generic file system description for types that don't have a more specific description.")
      } else {
        return String(localized: "Data", bundle: .module, comment: "Default generic description for types that don't have a more specific description.")
      }
    }
  }
}

// MARK: -

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension FormatStyle where Self == MediaType.GenericFormatStyle {
  public static var generic: Self {
    get {
      return Self(context: nil)
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Formats a media type as a localized description that is suitable for use
  /// as a specific description of the type, e.g. `"JPEG image"` or `"MP4 Video"`.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public struct SpecificFormatStyle: FormatStyle {
    
    /// Formats a value, using this style.
    public func format(_ type: MediaType) -> String {
      if let type = UTType(mediaType: type), let description = type.localizedDescription?.conditionalCapitalized {
        return description
      } else {
        return type.rawValue
      }
    }
  }
}

// MARK: -

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension FormatStyle where Self == MediaType.SpecificFormatStyle {
  public static var specific: Self {
    get {
      return Self()
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Formats a media type as a localized file name suitable for use as a
  /// default name for files of that type.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public struct FileNameFormatStyle: FormatStyle {
    
    /// Returns the file extension to use for the given media type.
    private func fileExtension(for type: MediaType) -> String? {
      
      /// First try the UTType's preferred file name extension.
      if let type = UTType(mediaType: type) {
        if let ext = type.preferredFilenameExtension, !ext.isEmpty {
          return ext
        }
        
        /// Apple platforms don't register preferred file name extensions for
        /// plain text types such as UTF-8, UTF-16 etc.
        if type.conforms(to: .plainText) {
          return "txt"
        }
      }
        
      /// Add support for common media types not registered by default on
      /// Apple platforms.
      if type.matches(.text(.markdown)) {
        return "md"
      } else {
        return nil
      }
    }
    
    /// Formats a value, using this style.
    public func format(_ type: MediaType) -> String {
      let baseName = type.formatted(GenericFormatStyle(context: .file))
      
      if let ext = fileExtension(for: type) {
        return "\(baseName).\(ext)"
      } else {
        return baseName
      }
    }
  }
}

// MARK: -

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension FormatStyle where Self == MediaType.FileNameFormatStyle {
  public static var fileName: Self {
    get {
      return Self()
    }
  }
}

// MARK: -

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension MediaType {
  
  /// Formats the receiver using the given style.
  public func formatted<S>(_ style: S) -> S.FormatOutput where S: FormatStyle, S.FormatInput == Self, S.FormatOutput == String {
    return style.format(self)
  }
  
  /// Formats the receiver using the default style.
  public func formatted() -> String {
    return formatted(.specific)
  }
}
