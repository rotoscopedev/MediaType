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
  
  func test_initializer() {
    let type = MediaType("text/plain")
    expect(type) == "text/plain"
  }
  
  // MARK: - RawRepresentable
  
  func test_rawValue() {
    let type = MediaType(rawValue: "text/plain")
    expect(type).toNot(beNil())
    expect(type!.rawValue) == "text/plain"
  }
  
  func test_rawValueEmpty() {
    let type = MediaType(rawValue: "")
    expect(type).to(beNil())
  }
  
  // MARK: - Initialization
  
  func test_initializeType() {
    let type = MediaType(type: .text)
    expect(type.rawValue) == "text"
  }
  
  func test_initializeSubtype() {
    let type = MediaType(type: .text, subtype: "plain")
    expect(type.rawValue) == "text/plain"
  }
  
  func test_initializeTree() {
    let type = MediaType(type: .audio, facet: MediaType.Tree.vendor.facet, subtype: "dolby.pl2")
    expect(type.rawValue) == "audio/vnd.dolby.pl2"
  }
  
  func test_initializeSuffix() {
    let type = MediaType(type: .application, subtype: "atom", suffix: "xml")
    expect(type.rawValue) == "application/atom+xml"
  }
  
  func test_initializeTreeAndSuffix() {
    let type = MediaType(type: .application, facet: MediaType.Tree.vendor.facet, subtype: "3gpp.bsf", suffix: "xml")
    expect(type.rawValue) == "application/vnd.3gpp.bsf+xml"
  }
  
  func test_initializeParameters() {
    let type = MediaType(type: .text, subtype: "html", parameters: [ "charset" : "UTF-8" ])
    expect(type.rawValue) == "text/html; charset=UTF-8"
  }

  func test_initializeParametersSorting() {
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

  func test_initializeEmptyParameters() {
    let type = MediaType(type: .text, subtype: "html", parameters: [:])
    expect(type.rawValue) == "text/html"
  }
  
  // MARK: -
  
  func test_initializeTypeCasing() {
    let type = MediaType(type: .other("Movie"), subtype: "avi")
    expect(type.rawValue) == "Movie/avi"
  }

  func test_initializeSubtypeCasing() {
    let type = MediaType(type: .text, subtype: "SGML")
    expect(type.rawValue) == "text/SGML"
  }

  func test_initializeSuffixCasing() {
    let type = MediaType(type: .application, subtype: "ld", suffix: "JSON")
    expect(type.rawValue) == "application/ld+JSON"
  }

  func test_initializeParametersCasing() {
    let type = MediaType(type: .text, subtype: "html", parameters: [ "CharSet" : "UTF-8" ])
    expect(type.rawValue) == "text/html; CharSet=UTF-8"
  }

  // MARK: - Type
  
  func test_type() {
    let type: MediaType = "text/plain"
    expect(type.type) == .text
  }
  
  func test_typeOnly() {
    let type: MediaType = "image"
    expect(type.type) == .image
  }
  
  func test_typeWithTrailingDelimiter1() {
    let type: MediaType = "video/"
    expect(type.type) == .video
  }
  
  func test_typeWithTrailingDelimiter2() {
    let type: MediaType = "video;"
    expect(type.type) == .video
  }
  
  func test_typeCasing() {
    let type: MediaType = "TeXt/plain"
    expect(type.type) == .text
    expect(type.type.rawValue) == "text"
  }
  
  // MARK: - Subtype
  
  func test_subtype() {
    let type: MediaType = "text/plain"
    expect(type.subtype) == "plain"
  }
  
  func test_noSubtype() {
    let type: MediaType = "text"
    expect(type.subtype).to(beNil())
  }
  
  func test_subtypeWithTrailingDelimiter1() {
    let type: MediaType = "text/plain;"
    expect(type.subtype) == "plain"
  }
  
  func test_subtypeWithTrailingDelimiter2() {
    let type: MediaType = "text/plain+"
    expect(type.subtype) == "plain"
  }
  
  func test_subtypeCasing() {
    let type: MediaType = "text/SGML"
    expect(type.subtype) == "SGML"
  }
  
  // MARK: - Facet
  
  func test_facet() {
    let type: MediaType = "application/vnd.amazon.ebook"
    expect(type.facet) == "vnd"
  }
  
  func test_noFacet() {
    let type: MediaType = "text/plain"
    expect(type.facet).to(beNil())
  }
  
  func test_facetNoSubtype() {
    let type: MediaType = "text"
    expect(type.facet).to(beNil())
  }
  
  func test_facetWithSubtypeWithMultiplePeriods() {
    let type: MediaType = "text/vnd.rtf.dir"
    expect(type.subtype) == "rtf.dir"
    expect(type.facet) == "vnd"
  }

  func test_facetWithTrailingDelimiter1() {
    let type: MediaType = "application/vnd.amazon.ebook;"
    expect(type.facet) == "vnd"
  }
  
  func test_facetWithTrailingDelimiter2() {
    let type: MediaType = "application/vnd.amazon.ebook+"
    expect(type.facet) == "vnd"
  }
  
  func test_facetCasing() {
    let type: MediaType = "application/VND.amazon.ebook"
    expect(type.facet) == "VND"
  }

  // MARK: - Tree
  
  func test_tree() {
    let type: MediaType = "application/vnd.amazon.ebook"
    expect(type.tree) == .vendor
  }
  
  func test_noTree() {
    let type: MediaType = "text/plain"
    expect(type.tree) == .standards
  }
  
  func test_treeNoSubtype() {
    let type: MediaType = "text"
    expect(type.tree) == .standards
  }
  
  func test_treeWithSubtypeWithMultiplePeriods() {
    let type: MediaType = "text/vnd.rtf.dir"
    expect(type.subtype) == "rtf.dir"
    expect(type.tree) == .vendor
  }

  func test_treeWithTrailingDelimiter1() {
    let type: MediaType = "application/vnd.amazon.ebook;"
    expect(type.tree) == .vendor
  }
  
  func test_treeWithTrailingDelimiter2() {
    let type: MediaType = "application/vnd.amazon.ebook+"
    expect(type.tree) == .vendor
  }
  
  func test_treeCasing() {
    let type: MediaType = "application/VND.amazon.ebook"
    expect(type.tree) == .vendor
  }
  
  // MARK: - Suffix
  
  func test_suffix() {
    let type: MediaType = "application/epub+zip"
    expect(type.suffix) == "zip"
  }
  
  func test_noSuffix() {
    let type: MediaType = "image/png"
    expect(type.suffix).to(beNil())
  }
  
  func test_suffixForSubtypeWithMultiplePlusChars() {
    let type: MediaType = "image/jpeg+2000+q10"
    expect(type.suffix) == "q10"
  }

  func test_suffixNoSubtype() {
    let type: MediaType = "image"
    expect(type.suffix).to(beNil())
  }
  
  func test_suffixWithTrailingDelimiter() {
    let type: MediaType = "application/ld+json;"
    expect(type.suffix) == "json"
  }
  
  func test_suffixCasing() {
    let type: MediaType = "application/ld+JSON"
    expect(type.suffix) == "JSON"
  }
  
  func test_addSuffix() {
    let type: MediaType = "application/ld"
    expect(type.adding(suffix: "json")) == "application/ld+json"
  }
  
  func test_replaceSuffix() {
    let type: MediaType = "application/ld+xml"
    expect(type.adding(suffix: "json")) == "application/ld+json"
  }
  
  func test_removeSuffix() {
    let type: MediaType = "application/ld+json"
    expect(type.removingSuffix()) == "application/ld"
  }

  // MARK: - Parameters
  
  func test_parameter() {
    let type: MediaType = "text/html; charset=UTF-8"
    expect(type["charset"]) == "UTF-8"
  }
  
  func test_noParameters() {
    let type: MediaType = "text/html"
    expect(type["charset"]).to(beNil())
  }
  
  func test_missingParameters() {
    let type: MediaType = "text/html; charset=UTF-8"
    expect(type["linebreak"]).to(beNil())
  }

  func test_multipleParameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    expect(type["charset"]) == "UTF-8"
    expect(type["linebreak"]) == "lf"
  }
  
  func test_duplicateParameters() {
    let type: MediaType = "text/html; charset=UTF-8; charset=US-ASCII"
    expect(type["charset"]) == "UTF-8"
  }
  
  func test_parametersWithTrailingDelimiter() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf;"
    expect(type["charset"]) == "UTF-8"
    expect(type["linebreak"]) == "lf"
  }
  
  func test_parametersWithExtraneousDelimiters() {
    let type: MediaType = "text/html; charset=UTF-8;; linebreak=lf;;;"
    expect(type["charset"]) == "UTF-8"
    expect(type["linebreak"]) == "lf"
  }

  func test_parameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    let expected = [
      "charset" : "UTF-8",
      "linebreak" : "lf",
    ]
    expect(type.parameters) == expected
  }

  func test_parametersEmpty() {
    let type: MediaType = "text/html"
    expect(type.parameters) == [:]
  }
  
  func test_parametersWithSurroundingWhitespace() {
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
  
  func test_addParameter() {
    let type: MediaType = "text/markdown"
    expect(type.adding(parameter: "charset", value: "UTF-8")) == "text/markdown; charset=UTF-8"
  }
  
  func test_addParameterCasing() {
    let type: MediaType = "text/markdown"
    expect(type.adding(parameter: "CharSet", value: "UTF-8")) == "text/markdown; CharSet=UTF-8"
  }

  func test_replaceParameter() {
    let type: MediaType = "text/markdown; charset=US-ASCII"
    expect(type.adding(parameter: "charset", value: "UTF-8")) == "text/markdown; charset=UTF-8"
  }
  
  func test_replaceParameterCasing() {
    let type: MediaType = "text/markdown; CHARSET=US-ASCII"
    expect(type.adding(parameter: "CharSet", value: "UTF-8")) == "text/markdown; CharSet=UTF-8"
  }

  // MARK: -
  
  func test_removeParameter() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    expect(type.removing(parameter: "charset")) == "text/html; linebreak=lf"
  }
  
  func test_removeNonExistentParameter() {
    let type: MediaType = "text/html; charset=UTF-8"
    expect(type.removing(parameter: "linebreak")) == "text/html; charset=UTF-8"
  }

  func test_removeParameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    expect(type.removingParameters()) == "text/html"
  }
  
  func test_removeNoParameters() {
    let type: MediaType = "text/html"
    expect(type.removingParameters()) == "text/html"
  }
  
  func test_removeParameterCasing() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    expect(type.removing(parameter: "CharSet")) == "text/html; linebreak=lf"
  }
  
  // MARK: - Normalization
  
  func test_normalizedType() {
    let type = MediaType(type: .other("VIDEO"), subtype: "avi")
    expect(type) == "VIDEO/avi"
    expect(type.normalized()) == "video/avi"
  }
  
  func test_normalizedSubtype() {
    let type = MediaType(type: .text, subtype: "SGML")
    expect(type) == "text/SGML"
    expect(type.normalized()) == "text/sgml"
  }

  func test_normalizeSubtypeWhitespace() {
    let type: MediaType = " text / plain"
    expect(type.normalized()) == "text/plain"
  }

  func test_normalizeFacet() {
    let type = MediaType(type: .application, facet: "VND", subtype: "adobe.photoshop")
    expect(type) == "application/VND.adobe.photoshop"
    expect(type.normalized()) == "application/vnd.adobe.photoshop"
  }
  
  func test_normalizeSuffix() {
    let type = MediaType(type: .application, subtype: "ld", suffix: "JSON")
    expect(type) == "application/ld+JSON"
    expect(type.normalized()) == "application/ld+json"
  }
  
  func test_normalizeParameterName() {
    let type = MediaType(type: .text, subtype: "plain", parameters: [ "CharSet" : "UTF-8" ])
    expect(type) == "text/plain; CharSet=UTF-8"
    expect(type.normalized()) == "text/plain; charset=UTF-8"
  }
  
  func test_normalizeParameterOrder() {
    let type: MediaType = "text/plain; first=1st; second=2nd; third=3rd; fourth=4th; fifth=5th"
    expect(type.normalized()) == "text/plain; fifth=5th; first=1st; fourth=4th; second=2nd; third=3rd"
  }

  func test_normalizeParameterWhitespace() {
    let type: MediaType = " text/plain ; charset = UTF-8 ; linebreak = lf "
    expect(type.normalized()) == "text/plain; charset=UTF-8; linebreak=lf"
  }
  
  func test_normalizeParameterDelimiters() {
    let type: MediaType = "text/plain; charset = UTF-8; linebreak = lf;"
    expect(type.normalized()) == "text/plain; charset=UTF-8; linebreak=lf"
  }
  
  func test_normalizeDuplicateParameters() {
    let type: MediaType = "text/plain; charset=UTF-8; charset=US-ASCII; charset: ISO-8859-1"
    expect(type.normalized()) == "text/plain; charset=UTF-8"
  }

  // MARK: - Subtype Factory Methods
  
  func test_applicationSubtype() {
    let type: MediaType = .application(.pkcs8)
    expect(type.rawValue) == "application/pkcs8"
  }
  
  func test_audioSubtype() {
    let type: MediaType = .audio(.mpeg)
    expect(type.rawValue) == "audio/mpeg"
  }
  
  func test_fontSubtype() {
    let type: MediaType = .font(.otf)
    expect(type.rawValue) == "font/otf"
  }
  
  func test_imageSubtype() {
    let type: MediaType = .image(.png)
    expect(type.rawValue) == "image/png"
  }
  
  func test_messageSubtype() {
    let type: MediaType = .message(.http)
    expect(type.rawValue) == "message/http"
  }
  
  func test_modelSubtype() {
    let type: MediaType = .model(.obj)
    expect(type.rawValue) == "model/obj"
  }
  
  func test_multipartSubtype() {
    let type: MediaType = .multipart(.digest)
    expect(type.rawValue) == "multipart/digest"
  }
  
  func test_textSubtype() {
    let type: MediaType = .text(.css)
    expect(type.rawValue) == "text/css"
  }
  
  func test_videoSubtype() {
    let type: MediaType = .video(.h264)
    expect(type.rawValue) == "video/H264"
  }
  
  // MARK: - Coding
  
  func test_encoding() throws {
    let encoder = JSONEncoder()
    let type: MediaType = .application(.json)
    
    let output = try encoder.encode(type)
    let string = String(bytes: output, encoding: .utf8)!
    
    expect(string) == #""application\/json""#
  }
  
  func test_decoding() throws {
    let decoder = JSONDecoder()
    let input = #""application\/json""#.data(using: .utf8)!
    
    let type = try decoder.decode(MediaType.self, from: input)
    expect(type) == .application(.json)
  }
  
  // MARK: - Markdown
  
  func test_markdownTypes() {
    expect(MediaType.text(.markdown)) == "text/markdown"
    expect(MediaType.text(.commonMark)) == "text/markdown; variant=CommonMark"
  }
  
  // MARK: - Matching
  
  func test_matchesTopLevelType() {
    expect(MediaType("text/plain").matches("text")) == true
    expect(MediaType("text/plain").matches("image")) == false
    expect(MediaType("text").matches("text/plain")) == false
    expect(MediaType("TEXT/PLAIN").matches("text")) == true
  }
  
  func test_matchesFacet() {
    expect(MediaType("application/vnd.oasis.opendocument.chart").matches("application/vnd.oasis.opendocument.chart")) == true
    expect(MediaType("application/vnd.oasis.opendocument.chart").matches("application/x.oasis.opendocument.chart")) == false
    expect(MediaType("Application/VND.Oasis.OpenDocument.Chart").matches("application/vnd.oasis.opendocument.chart")) == true
    expect(MediaType("application/vnd.oasis.opendocument.chart").matches("application/vnd.oasis.opendocument.chart")) == true
  }

  func test_matchesSubtype() {
    expect(MediaType("text/plain").matches("text/plain")) == true
    expect(MediaType("text/plain").matches("text/html")) == false
    expect(MediaType("text/html").matches("application/html")) == false
    expect(MediaType("text/PLAIN").matches("text/plain")) == true
  }

  func test_matchesSuffix() {
    expect(MediaType("application/soap+xml").matches("application/soap+xml")) == true
    expect(MediaType("application/soap+xml").matches("application/soap")) == true
    expect(MediaType("application/soap+xml").matches("application/soap+json")) == false
    expect(MediaType("application/soap+xml").matches("application/soap+XML")) == true
  }

  func test_matchesParameters() {
    expect(MediaType("text/plain; charset=UTF-8").matches("text/plain")) == true
    expect(MediaType("text/plain; charset=UTF-8").matches("text/plain; charset=UTF-8")) == true
    expect(MediaType("text/plain; charset=UTF-8").matches("text/plain; charset=UTF-16")) == false
    expect(MediaType("text/plain").matches("text/plain; charset=UTF-8")) == false

    expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown")) == true
    expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-8")) == true
    expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-8; variant=CommonMark")) == true
    expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-16")) == false
    expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-8; variant=pandoc")) == false
  }
  
  // MARK: -
  
  func test_charset() {
    expect(MediaType("text/plain").charset).to(beNil())
    expect(MediaType("text/plain; charset=UTF-8").charset) == .utf8
    expect(MediaType("text/plain; charset=UTF-8").charset) == .utf8
  }
  
  func test_setCharset() {
    let type = MediaType("text/plain").charset(.utf8)
    expect(type) == "text/plain; charset=UTF-8"
  }
}
