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
  
  /// Returns a locale-sensitive, humanly-readable description of the type.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public func formatted() -> String {
    if let type = UTType(mediaType: self), let description = type.localizedDescription, !description.isEmpty {
      return description.conditionalCapitalized
    } else {
      return switch type {
      case .application:
        String(localized: "Application document", bundle: .module, comment: "Description for application media types.")
      case .audio:
        String(localized: "Audio", bundle: .module, comment: "Description for audio media types.")
      case .font:
        String(localized: "Font", bundle: .module, comment: "Description for font media types.")
      case .haptics:
        String(localized: "Haptics", bundle: .module, comment: "Description for haptics media types.")
      case .image:
        String(localized: "Image", bundle: .module, comment: "Description for image media types.")
      case .message:
        String(localized: "Message", bundle: .module, comment: "Description for message media types.")
      case .model:
        String(localized: "2D/3D model", bundle: .module, comment: "Description for model media types.")
      case .multipart:
        String(localized: "Multipart", bundle: .module, comment: "Description for multipart media types.")
      case .text:
        String(localized: "Text", bundle: .module, comment: "Description for text media types.")
      case .video:
        String(localized: "Video", bundle: .module, comment: "Description for vide media types.")
      default:
        rawValue
      }
    }
  }
}
