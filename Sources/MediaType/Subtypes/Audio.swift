// --------------------------------------------------------------------------
//
// Copyright (c) Rotoscope GmbH, 2020.
// All Rights Reserved.
//
// This software is provided "as is," without warranty of any kind, express
// or implied. In no event shall the author or contributors be held liable
// for any damages arising in any way from the use of this software.
//
// --------------------------------------------------------------------------

public enum AudioSubtype: String {
  case aac = "aac"
  case ac3 = "ac3"
  case midi = "midi"
  case mp4 = "mp4"
  case mpeg = "mpeg"
  case ogg = "ogg"
  case pcma = "PCMA"
  case vorbis = "vorbis"
}

// MARK: -

extension MediaType {

  /// Returns an audio media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An audio subtype.
  public static func audio(_ subtype: AudioSubtype) -> MediaType {
    return audio(subtype.rawValue)
  }

  /// Returns an audio media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An audio subtype string.
  public static func audio(_ subtype: String) -> MediaType {
    return MediaType(type: "audio", subtype: subtype)
  }
}
