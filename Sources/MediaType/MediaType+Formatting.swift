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

extension MediaType {

  /// Formats a media type as a localized description that is suitable for use
  /// as a generic description of the type, e.g. `"Image"` for image types,
  /// `"Video"` for video types, etc.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public struct GenericFormatStyle: FormatStyle {
    
    /// Formats a value, using this style.
    public func format(_ type: MediaType) -> String {
      if let description = UTType.GenericFormatStyle().description(for: UTType(mediaType: type)) {
        return description
      } else {
        return switch type.type {
        case .audio:          String(localized: "Audio", bundle: .module, comment: "Default description for audio media types.")
        case .font:           String(localized: "Font", bundle: .module, comment: "Default description for font media types.")
        case .haptics:        String(localized: "Haptics", bundle: .module, comment: "Default description for haptics media types.")
        case .image:          String(localized: "Image", bundle: .module, comment: "Default description for image media types.")
        case .message:        String(localized: "Message", bundle: .module, comment: "Default description for message media types.")
        case .model:          String(localized: "Model", bundle: .module, comment: "Default description for model media types.")
        case .text:           String(localized: "Text", bundle: .module, comment: "Default description for model media types.")
        case .video:          String(localized: "Video", bundle: .module, comment: "Default description for video media types.")
        default:              String(localized: "Data", bundle: .module, comment: "Default description for media types.")
        }
      }
    }
  }
}

// MARK: -

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
extension FormatStyle where Self == MediaType.GenericFormatStyle {
  public static var generic: Self {
    get {
      return Self()
    }
  }
}

// MARK: -

extension MediaType {
  
  /// Formats a media type as a localized description that is suitable for use
  /// as a specific description of the type, e.g. `"JPEG image"` or
  /// `"MP4 Video"`.
  ///
  /// If a specific description is not available then a generic description is
  /// used.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public struct SpecificFormatStyle: FormatStyle {
    
    /// Formats a value, using this style.
    public func format(_ type: MediaType) -> String {
      if let type = UTType(mimeType: type.rawValue, conformingTo: .data), !type.isDynamic {
        return type.formatted(.specific)
      } else {
        return type.formatted(.generic)
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
