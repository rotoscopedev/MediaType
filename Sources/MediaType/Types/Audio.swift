//
// MIT License
//
// Copyright (c) 2020 Rotoscope GmbH
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
  public struct AudioSubtype: Subtype {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.AudioSubtype {
  public static let aac: Self = "aac"
  public static let ac3: Self = "ac3"
  public static let aiff: Self = "aiff"
  public static let caf: Self = "x-caf"
  public static let l17: Self = "L16"
  public static let midi: Self = "midi"
  public static let mp4: Self = "mp4"
  public static let mpeg: Self = "mpeg"
  public static let ogg: Self = "ogg"
  public static let pcma: Self = "PCMA"
  public static let vorbis: Self = "vorbis"
  public static let wav: Self = "wav"
  public static let webm: Self = "webm"
}

// MARK: -

extension MediaType {

  /// Returns an audio media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An audio subtype.
  public static func audio(_ subtype: AudioSubtype) -> Self {
    return audio(subtype.rawValue)
  }

  /// Returns an audio media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An audio subtype string.
  public static func audio(_ subtype: String) -> Self {
    return Self(type: "audio", subtype: subtype)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `audio` top-level type. The media type does not have
  /// a sub-type.
  public static let audio = Self(type: .audio)
}
