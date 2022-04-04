//
// MIT License
//
// Copyright (c) 2022 Rotoscope GmbH
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

import Nimble
import XCTest

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

@testable import MediaType

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
class UTTypeTests: XCTestCase {

  func test_initializeUTType() {
    expect(UTType(mediaType: .image(.png))) == .png
    expect(UTType(mediaType: .text(.html))) == .html
  }
  
  func test_initializeUTTypeCasing() {
    expect(UTType(mediaType: MediaType(rawValue: "IMAGE/PNG")!)) == .png
    expect(UTType(mediaType: MediaType(rawValue: "text/HTML")!)) == .html
  }

  func test_initializeUTTypeFromPlainText() {
    expect(UTType(mediaType: .text(.plain))) == .plainText
    expect(UTType(mediaType: .text(.plain).adding(parameter: "charset", value: "UTF-8"))) == .utf8PlainText
    expect(UTType(mediaType: .text(.plain).adding(parameter: "charset", value: "UTF-16"))) == .utf16PlainText
    expect(UTType(mediaType: .text(.plain).adding(parameter: "charset", value: "UTF-16LE"))) == .utf16PlainText
    expect(UTType(mediaType: .text(.plain).adding(parameter: "charset", value: "UTF-16BE"))) == .utf16PlainText
  }

  func test_initializeUTTypeFromPlainTextCasing() {
    expect(UTType(mediaType: MediaType(rawValue: "Text/Plain")!)) == .plainText
    expect(UTType(mediaType: MediaType(rawValue: "Text/Plain; CharSet=UTF-8")!)) == .utf8PlainText
    expect(UTType(mediaType: MediaType(rawValue: "Text/Plain; charset=utf-16")!)) == .utf16PlainText
    expect(UTType(mediaType: MediaType(rawValue: "Text/Plain; CHARSET=Utf-16Le")!)) == .utf16PlainText
    expect(UTType(mediaType: MediaType(rawValue: "Text/Plain; charset=utf-16be")!)) == .utf16PlainText
  }

  func test_initializeUTTypeFromTopLevelType() {
    expect(UTType(mediaType: .application)).to(beNil())
    expect(UTType(mediaType: .audio)) == .audio
    expect(UTType(mediaType: .font)) == .font
    expect(UTType(mediaType: .image)) == .image
    expect(UTType(mediaType: .message)).to(beNil())
    expect(UTType(mediaType: .model)).to(beNil())
    expect(UTType(mediaType: .multipart)).to(beNil())
    expect(UTType(mediaType: .text)) == .text
    expect(UTType(mediaType: .video)) == .video
  }
  
  // MARK: -
  
  func test_preferredMediaType() {
    expect(UTType.plainText.preferredMediaType) == .text(.plain)
    expect(UTType.png.preferredMediaType) == .image(.png)
  }
  
  func test_preferredMediaTypeWithCharset() {
    expect(UTType.utf8PlainText.preferredMediaType) == .text(.plain).charset(.utf8)
    expect(UTType.utf16PlainText.preferredMediaType) == .text(.plain).charset(.utf16)
  }
}
