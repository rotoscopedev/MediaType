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

import Nimble
import XCTest

@testable import MediaType

class MediaTypeTests: XCTestCase {
  
  // MARK: - Initialization
  
  func testInitializer() {
    let type = MediaType("text/plain")
    expect(type) == "text/plain"
  }
  
  // MARK: - RawRepresentable
  
  func testRawValue() {
    let type = MediaType(rawValue: "text/plain")
    expect(type).toNot(beNil())
    expect(type!.rawValue) == "text/plain"
  }
  
  func testRawValueEmpty() {
    let type = MediaType(rawValue: "")
    expect(type).to(beNil())
  }
  
  // MARK: - Initialization
  
  func testInitializeType() {
    let type = MediaType(type: .text)
    expect(type.rawValue) == "text"
  }
  
  func testInitializeSubtype() {
    let type = MediaType(type: .text, subtype: "plain")
    expect(type.rawValue) == "text/plain"
  }
  
  func testInitializeTree() {
    let type = MediaType(type: .audio, facet: MediaType.Tree.vendor.facet, subtype: "dolby.pl2")
    expect(type.rawValue) == "audio/vnd.dolby.pl2"
  }
  
  func testInitializeSuffix() {
    let type = MediaType(type: .application, subtype: "atom", suffix: "xml")
    expect(type.rawValue) == "application/atom+xml"
  }
  
  func testInitializeTreeAndSuffix() {
    let type = MediaType(type: .application, facet: MediaType.Tree.vendor.facet, subtype: "3gpp.bsf", suffix: "xml")
    expect(type.rawValue) == "application/vnd.3gpp.bsf+xml"
  }
  
  func testInitializeParameters() {
    let type = MediaType(type: .text, subtype: "html", parameters: [ "charset" : "UTF-8" ])
    expect(type.rawValue) == "text/html; charset=UTF-8"
  }

  func testInitializeParametersSorting() {
    let params = [
      "first" : "1st",
      "second" : "2nd",
      "third" : "3rd",
      "fourth" : "4th",
      "fifth" : "5th",
    ]
    let type = MediaType(type: .text, subtype: "html", parameters: params)
    expect(type.rawValue) == "text/html; fifth=5th; first=1st; fourth=4th; second=2nd; third=3rd"
  }

  func testInitializeEmptyParameters() {
    let type = MediaType(type: .text, subtype: "html", parameters: [:])
    expect(type.rawValue) == "text/html"
  }
  
  // MARK: -
  
  func testInitializeTypeCasing() {
    let type = MediaType(type: .other("Movie"), subtype: "avi")
    expect(type.rawValue) == "Movie/avi"
  }

  func testInitializeSubtypeCasing() {
    let type = MediaType(type: .text, subtype: "SGML")
    expect(type.rawValue) == "text/SGML"
  }

  func testInitializeSuffixCasing() {
    let type = MediaType(type: .application, subtype: "ld", suffix: "JSON")
    expect(type.rawValue) == "application/ld+JSON"
  }

  func testInitializeParametersCasing() {
    let type = MediaType(type: .text, subtype: "html", parameters: [ "CharSet" : "UTF-8" ])
    expect(type.rawValue) == "text/html; CharSet=UTF-8"
  }

  // MARK: - Type
  
  func testType() {
    let type: MediaType = "text/plain"
    expect(type.type) == .text
  }
  
  func testTypeOnly() {
    let type: MediaType = "image"
    expect(type.type) == .image
  }
  
  func testTypeWithTrailingDelimiter1() {
    let type: MediaType = "video/"
    expect(type.type) == .video
  }
  
  func testTypeWithTrailingDelimiter2() {
    let type: MediaType = "video;"
    expect(type.type) == .video
  }
  
  func testTypeCasing() {
    let type: MediaType = "TeXt/plain"
    expect(type.type) == .text
    expect(type.type.rawValue) == "text"
  }
  
  // MARK: - Subtype
  
  func testSubtype() {
    let type: MediaType = "text/plain"
    expect(type.subtype) == "plain"
  }
  
  func testNoSubtype() {
    let type: MediaType = "text"
    expect(type.subtype).to(beNil())
  }
  
  func testSubtypeWithTrailingDelimiter1() {
    let type: MediaType = "text/plain;"
    expect(type.subtype) == "plain"
  }
  
  func testSubtypeWithTrailingDelimiter2() {
    let type: MediaType = "text/plain+"
    expect(type.subtype) == "plain"
  }
  
  func testSubtypeCasing() {
    let type: MediaType = "text/SGML"
    expect(type.subtype) == "SGML"
  }
  
  // MARK: - Facet
  
  func testFacet() {
    let type: MediaType = "application/vnd.amazon.ebook"
    expect(type.facet) == "vnd"
  }
  
  func testNoFacet() {
    let type: MediaType = "text/plain"
    expect(type.facet).to(beNil())
  }
  
  func testFacetNoSubtype() {
    let type: MediaType = "text"
    expect(type.facet).to(beNil())
  }
  
  func testFacetWithSubtypeWithMultiplePeriods() {
    let type: MediaType = "text/vnd.rtf.dir"
    expect(type.subtype) == "rtf.dir"
    expect(type.facet) == "vnd"
  }

  func testFacetWithTrailingDelimiter1() {
    let type: MediaType = "application/vnd.amazon.ebook;"
    expect(type.facet) == "vnd"
  }
  
  func testFacetWithTrailingDelimiter2() {
    let type: MediaType = "application/vnd.amazon.ebook+"
    expect(type.facet) == "vnd"
  }
  
  func testFacetCasing() {
    let type: MediaType = "application/VND.amazon.ebook"
    expect(type.facet) == "VND"
  }

  // MARK: - Tree
  
  func testTree() {
    let type: MediaType = "application/vnd.amazon.ebook"
    expect(type.tree) == .vendor
  }
  
  func testNoTree() {
    let type: MediaType = "text/plain"
    expect(type.tree) == .standards
  }
  
  func testTreeNoSubtype() {
    let type: MediaType = "text"
    expect(type.tree) == .standards
  }
  
  func testTreeWithSubtypeWithMultiplePeriods() {
    let type: MediaType = "text/vnd.rtf.dir"
    expect(type.subtype) == "rtf.dir"
    expect(type.tree) == .vendor
  }

  func testTreeWithTrailingDelimiter1() {
    let type: MediaType = "application/vnd.amazon.ebook;"
    expect(type.tree) == .vendor
  }
  
  func testTreeWithTrailingDelimiter2() {
    let type: MediaType = "application/vnd.amazon.ebook+"
    expect(type.tree) == .vendor
  }
  
  func testTreeCasing() {
    let type: MediaType = "application/VND.amazon.ebook"
    expect(type.tree) == .vendor
  }
  
  // MARK: - Suffix
  
  func testSuffix() {
    let type: MediaType = "application/epub+zip"
    expect(type.suffix) == "zip"
  }
  
  func testNoSuffix() {
    let type: MediaType = "image/png"
    expect(type.suffix).to(beNil())
  }
  
  func testSuffixForSubtypeWithMultiplePlusChars() {
    let type: MediaType = "image/jpeg+2000+q10"
    expect(type.suffix) == "q10"
  }

  func testSuffixNoSubtype() {
    let type: MediaType = "image"
    expect(type.suffix).to(beNil())
  }
  
  func testSuffixWithTrailingDelimiter() {
    let type: MediaType = "application/ld+json;"
    expect(type.suffix) == "json"
  }
  
  func testSuffixCasing() {
    let type: MediaType = "application/ld+JSON"
    expect(type.suffix) == "JSON"
  }
  
  func testAddSuffix() {
    let type: MediaType = "application/ld"
    expect(type.adding(suffix: "json")) == "application/ld+json"
  }
  
  func testReplaceSuffix() {
    let type: MediaType = "application/ld+xml"
    expect(type.adding(suffix: "json")) == "application/ld+json"
  }
  
  func testRemoveSuffix() {
    let type: MediaType = "application/ld+json"
    expect(type.removingSuffix()) == "application/ld"
  }

  // MARK: - Parameters
  
  func testParameter() {
    let type: MediaType = "text/html; charset=UTF-8"
    expect(type["charset"]) == "UTF-8"
  }
  
  func testNoParameters() {
    let type: MediaType = "text/html"
    expect(type["charset"]).to(beNil())
  }
  
  func testMissingParameters() {
    let type: MediaType = "text/html; charset=UTF-8"
    expect(type["linebreak"]).to(beNil())
  }

  func testMultipleParameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    expect(type["charset"]) == "UTF-8"
    expect(type["linebreak"]) == "lf"
  }
  
  func testDuplicateParameters() {
    let type: MediaType = "text/html; charset=UTF-8; charset=US-ASCII"
    expect(type["charset"]) == "UTF-8"
  }
  
  func testParametersWithTrailingDelimiter() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf;"
    expect(type["charset"]) == "UTF-8"
    expect(type["linebreak"]) == "lf"
  }
  
  func testParametersWithExtraneousDelimiters() {
    let type: MediaType = "text/html; charset=UTF-8;; linebreak=lf;;;"
    expect(type["charset"]) == "UTF-8"
    expect(type["linebreak"]) == "lf"
  }

  func testParameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    let expected = [
      "charset" : "UTF-8",
      "linebreak" : "lf",
    ]
    expect(type.parameters) == expected
  }

  func testParametersEmpty() {
    let type: MediaType = "text/html"
    expect(type.parameters) == [:]
  }
  
  func testParametersWithSurroundingWhitespace() {
    let type: MediaType = "text/html; charset = UTF-8 ; linebreak = lf "
    expect(type["charset"]) == "UTF-8"
    expect(type["linebreak"]) == "lf"
    let expected = [
      "charset" : "UTF-8",
      "linebreak" : "lf",
    ]
    expect(type.parameters) == expected
  }
  
  // MARK: -
  
  func testAddParameter() {
    let type: MediaType = "text/markdown"
    expect(type.adding(parameter: "charset", value: "UTF-8")) == "text/markdown; charset=UTF-8"
  }
  
  func testAddParameterCasing() {
    let type: MediaType = "text/markdown"
    expect(type.adding(parameter: "CharSet", value: "UTF-8")) == "text/markdown; CharSet=UTF-8"
  }

  func testReplaceParameter() {
    let type: MediaType = "text/markdown; charset=US-ASCII"
    expect(type.adding(parameter: "charset", value: "UTF-8")) == "text/markdown; charset=UTF-8"
  }
  
  func testReplaceParameterCasing() {
    let type: MediaType = "text/markdown; CHARSET=US-ASCII"
    expect(type.adding(parameter: "CharSet", value: "UTF-8")) == "text/markdown; CharSet=UTF-8"
  }

  // MARK: -
  
  func testRemoveParameter() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    expect(type.removing(parameter: "charset")) == "text/html; linebreak=lf"
  }
  
  func testRemoveNonExistentParameter() {
    let type: MediaType = "text/html; charset=UTF-8"
    expect(type.removing(parameter: "linebreak")) == "text/html; charset=UTF-8"
  }

  func testRemoveParameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    expect(type.removingParameters()) == "text/html"
  }
  
  func testRemoveNoParameters() {
    let type: MediaType = "text/html"
    expect(type.removingParameters()) == "text/html"
  }
  
  func testRemoveParameterCasing() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    expect(type.removing(parameter: "CharSet")) == "text/html; linebreak=lf"
  }
  
  // MARK: - Normalization
  
  func testNormalizedType() {
    let type = MediaType(type: .other("VIDEO"), subtype: "avi")
    expect(type) == "VIDEO/avi"
    expect(type.normalized()) == "video/avi"
  }
  
  func testNormalizedSubtype() {
    let type = MediaType(type: .text, subtype: "SGML")
    expect(type) == "text/SGML"
    expect(type.normalized()) == "text/sgml"
  }

  func testNormalizeSubtypeWhitespace() {
    let type: MediaType = " text / plain"
    expect(type.normalized()) == "text/plain"
  }

  func testNormalizeFacet() {
    let type = MediaType(type: .application, facet: "VND", subtype: "adobe.photoshop")
    expect(type) == "application/VND.adobe.photoshop"
    expect(type.normalized()) == "application/vnd.adobe.photoshop"
  }
  
  func testNormalizeSuffix() {
    let type = MediaType(type: .application, subtype: "ld", suffix: "JSON")
    expect(type) == "application/ld+JSON"
    expect(type.normalized()) == "application/ld+json"
  }
  
  func testNormalizeParameterName() {
    let type = MediaType(type: .text, subtype: "plain", parameters: [ "CharSet" : "UTF-8" ])
    expect(type) == "text/plain; CharSet=UTF-8"
    expect(type.normalized()) == "text/plain; charset=UTF-8"
  }
  
  func testNormalizeParameterOrder() {
    let type: MediaType = "text/plain; first=1st; second=2nd; third=3rd; fourth=4th; fifth=5th"
    expect(type.normalized()) == "text/plain; fifth=5th; first=1st; fourth=4th; second=2nd; third=3rd"
  }

  func testNormalizeParameterWhitespace() {
    let type: MediaType = " text/plain ; charset = UTF-8 ; linebreak = lf "
    expect(type.normalized()) == "text/plain; charset=UTF-8; linebreak=lf"
  }
  
  func testNormalizeParameterDelimiters() {
    let type: MediaType = "text/plain; charset = UTF-8; linebreak = lf;"
    expect(type.normalized()) == "text/plain; charset=UTF-8; linebreak=lf"
  }
  
  func testNormalizeDuplicateParameters() {
    let type: MediaType = "text/plain; charset=UTF-8; charset=US-ASCII; charset: ISO-8859-1"
    expect(type.normalized()) == "text/plain; charset=UTF-8"
  }

  // MARK: - Subtype Factory Methods
  
  func testApplicationSubtype() {
    let type: MediaType = .application(.pkcs8)
    expect(type.rawValue) == "application/pkcs8"
  }
  
  func testAudioSubtype() {
    let type: MediaType = .audio(.mpeg)
    expect(type.rawValue) == "audio/mpeg"
  }
  
  func testFontSubtype() {
    let type: MediaType = .font(.otf)
    expect(type.rawValue) == "font/otf"
  }
  
  func testImageSubtype() {
    let type: MediaType = .image(.png)
    expect(type.rawValue) == "image/png"
  }
  
  func testMessageSubtype() {
    let type: MediaType = .message(.http)
    expect(type.rawValue) == "message/http"
  }
  
  func testModelSubtype() {
    let type: MediaType = .model(.obj)
    expect(type.rawValue) == "model/obj"
  }
  
  func testMultipartSubtype() {
    let type: MediaType = .multipart(.digest)
    expect(type.rawValue) == "multipart/digest"
  }
  
  func testTextSubtype() {
    let type: MediaType = .text(.css)
    expect(type.rawValue) == "text/css"
  }
  
  func testVideoSubtype() {
    let type: MediaType = .video(.h264)
    expect(type.rawValue) == "video/H264"
  }
  
  // MARK: - Coding
  
  func testEncoding() throws {
    let encoder = JSONEncoder()
    let type: MediaType = .application(.json)
    
    let output = try encoder.encode(type)
    let string = String(bytes: output, encoding: .utf8)!
    
    expect(string) == #""application\/json""#
  }
  
  func testDecoding() throws {
    let decoder = JSONDecoder()
    let input = #""application\/json""#.data(using: .utf8)!
    
    let type = try decoder.decode(MediaType.self, from: input)
    expect(type) == .application(.json)
  }
}
