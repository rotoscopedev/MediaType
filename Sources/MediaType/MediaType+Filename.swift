// --------------------------------------------------------------------------
//
// Copyright (c) Rotoscope GmbH, 2024.
// All Rights Reserved.
//
// This software is provided "as is," without warranty of any kind, express
// or implied. In no event shall the author or contributors be held liable
// for any damages arising in any way from the use of this software.
//
// --------------------------------------------------------------------------

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
