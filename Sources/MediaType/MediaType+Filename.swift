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
  
  /// Returns the preferred file extension to use for this media type.
  public var preferredFilenameExtension: String? {
    get {
      /// First try the types's file name extension.
      if let ext = UTType(mediaType: self).filenameExtension {
        return ext
      }
      
      /// Add support for common media types not registered by default on
      /// Apple platforms.
      if matches(.text(.markdown)) {
        return "md"
      } else {
        return nil
      }
    }
  }

  /// The preferred default file name for files of this type.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public var preferredFilename: String {
    get {
      return UTType(mediaType: self).preferredFilename(defaultExtension: preferredFilenameExtension)
    }
  }
}
