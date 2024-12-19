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

extension UTType {
  
  /// Returns the file extension to use for the given media type.
  var filenameExtension: String? {
    get {
      /// First try the types's preferred file name extension.
      if let ext = preferredFilenameExtension, !ext.isEmpty {
        return ext
      }
        
      /// Apple platforms don't register preferred file name extensions for
      /// plain text types such as UTF-8, UTF-16 etc.
      if conforms(to: .plainText) {
        return "txt"
      }
      return nil
    }
  }
  
  /// The preferred default file name for files of this type. The given
  /// file extension is used if an extension is not defined for this type.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  func preferredFilename(defaultExtension: String? = nil) -> String {
    let description = GenericFormatStyle().description(for: self)
    let baseName = description ?? String(localized: "File", bundle: .module, comment: "Default file base name for types without generic description.")
    
    if let ext = filenameExtension ?? defaultExtension {
      return "\(baseName).\(ext)"
    } else {
      return baseName
    }
  }

  /// The preferred default file name for files of this type.
  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1, *)
  public var preferredFilename: String {
    get {
      return preferredFilename()
    }
  }
}
