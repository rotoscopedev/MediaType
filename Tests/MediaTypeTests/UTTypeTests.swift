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

import Testing
import UniformTypeIdentifiers

@testable import MediaType

struct UTTypeTests {

  @Test func initializeUTType() {
    #expect(UTType(mediaType: .image(.png)) == .png)
    #expect(UTType(mediaType: .text(.html)) == .html)
  }
  
  @Test func initializeUTTypeCasing() {
    #expect(UTType(mediaType: MediaType(rawValue: "IMAGE/PNG")!) == .png)
    #expect(UTType(mediaType: MediaType(rawValue: "text/HTML")!) == .html)
  }

  @Test func initializeUTTypeFromPlainText() {
    #expect(UTType(mediaType: .text(.plain)) == .plainText)
    #expect(UTType(mediaType: .text(.plain).adding(parameter: "charset", value: "UTF-8")) == .utf8PlainText)
    #expect(UTType(mediaType: .text(.plain).adding(parameter: "charset", value: "UTF-16")) == .utf16PlainText)
    #expect(UTType(mediaType: .text(.plain).adding(parameter: "charset", value: "UTF-16LE")) == .utf16PlainText)
    #expect(UTType(mediaType: .text(.plain).adding(parameter: "charset", value: "UTF-16BE")) == .utf16PlainText)
  }

  @Test func initializeUTTypeFromPlainTextCasing() {
    #expect(UTType(mediaType: MediaType(rawValue: "Text/Plain")!) == .plainText)
    #expect(UTType(mediaType: MediaType(rawValue: "Text/Plain; CharSet=UTF-8")!) == .utf8PlainText)
    #expect(UTType(mediaType: MediaType(rawValue: "Text/Plain; charset=utf-16")!) == .utf16PlainText)
    #expect(UTType(mediaType: MediaType(rawValue: "Text/Plain; CHARSET=Utf-16Le")!) == .utf16PlainText)
    #expect(UTType(mediaType: MediaType(rawValue: "Text/Plain; charset=utf-16be")!) == .utf16PlainText)
  }

  @Test func initializeUTTypeFromTopLevelType() {
    #expect(UTType(mediaType: .application) == nil)
    #expect(UTType(mediaType: .audio) == .audio)
    #expect(UTType(mediaType: .font) == .font)
    #expect(UTType(mediaType: .image) == .image)
    #expect(UTType(mediaType: .message) == nil)
    #expect(UTType(mediaType: .model) == nil)
    #expect(UTType(mediaType: .multipart) == nil)
    #expect(UTType(mediaType: .text) == .text)
    #expect(UTType(mediaType: .video) == .video)
  }
  
  // MARK: -
  
  @Test func preferredMediaType() {
    #expect(UTType.plainText.preferredMediaType == .text(.plain))
    #expect(UTType.png.preferredMediaType == .image(.png))
  }
  
  @Test func preferredMediaTypeWithCharset() {
    #expect(UTType.utf8PlainText.preferredMediaType == .text(.plain).charset(.utf8))
    #expect(UTType.utf16PlainText.preferredMediaType == .text(.plain).charset(.utf16))
  }
}
