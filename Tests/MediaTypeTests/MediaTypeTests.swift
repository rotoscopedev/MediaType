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

import Foundation
import Testing

@testable import MediaType

struct MediaTypeTests {
  
  // MARK: - Initialization
  
  @Test func initializer() {
    let type = MediaType("text/plain")
    #expect(type == "text/plain")
  }
  
  // MARK: - RawRepresentable
  
  @Test func rawValue() {
    let type = MediaType(rawValue: "text/plain")
    #expect(type != nil)
    #expect(type!.rawValue == "text/plain")
  }
  
  @Test func rawValueEmpty() {
    let type = MediaType(rawValue: "")
    #expect(type == nil)
  }
  
  // MARK: - Initialization
  
  @Test func initializeType() {
    let type = MediaType(type: .text)
    #expect(type.rawValue == "text")
  }
  
  @Test func initializeSubtype() {
    let type = MediaType(type: .text, subtype: "plain")
    #expect(type.rawValue == "text/plain")
  }
  
  @Test func initializeTree() {
    let type = MediaType(type: .audio, facet: MediaType.Tree.vendor.facet, subtype: "dolby.pl2")
    #expect(type.rawValue == "audio/vnd.dolby.pl2")
  }
  
  @Test func initializeSuffix() {
    let type = MediaType(type: .application, subtype: "atom", suffix: "xml")
    #expect(type.rawValue == "application/atom+xml")
  }
  
  @Test func initializeTreeAndSuffix() {
    let type = MediaType(type: .application, facet: MediaType.Tree.vendor.facet, subtype: "3gpp.bsf", suffix: "xml")
    #expect(type.rawValue == "application/vnd.3gpp.bsf+xml")
  }
  
  @Test func initializeParameters() {
    let type = MediaType(
      type: .text,
      subtype: "html",
      parameters: [
        "charset" : "UTF-8"
      ]
    )
    #expect(type.rawValue == "text/html; charset=UTF-8")
  }

  @Test func initializeParametersSorting() {
    let params: MediaType.Parameters = [
      "first" : "1st",
      "second" : "2nd",
      "third" : "3rd",
      "fourth" : "4th",
      "fifth" : "5th",
    ]
    let type = MediaType(type: .text, subtype: "html", parameters: params)
    #expect(type.rawValue == "text/html; fifth=5th; first=1st; fourth=4th; second=2nd; third=3rd")
  }

  @Test func initializeEmptyParameters() {
    let type = MediaType(type: .text, subtype: "html", parameters: [])
    #expect(type.rawValue == "text/html")
  }
  
  // MARK: -
  
  @Test func initializeTypeCasing() {
    let type = MediaType(type: .other("Movie"), subtype: "avi")
    #expect(type.rawValue == "Movie/avi")
  }

  @Test func initializeSubtypeCasing() {
    let type = MediaType(type: .text, subtype: "SGML")
    #expect(type.rawValue == "text/SGML")
  }

  @Test func initializeSuffixCasing() {
    let type = MediaType(type: .application, subtype: "ld", suffix: "JSON")
    #expect(type.rawValue == "application/ld+JSON")
  }

  @Test func initializeParametersCasing() {
    let type = MediaType(
      type: .text,
      subtype: "html",
      parameters: [
        "CharSet" : "UTF-8"
      ]
    )
    #expect(type.rawValue == "text/html; CharSet=UTF-8")
  }

  // MARK: - Type
  
  @Test func type() {
    let type: MediaType = "text/plain"
    #expect(type.type == .text)
  }
  
  @Test func typeOnly() {
    let type: MediaType = "image"
    #expect(type.type == .image)
  }
  
  @Test func typeWithTrailingDelimiter1() {
    let type: MediaType = "video/"
    #expect(type.type == .video)
  }
  
  @Test func typeWithTrailingDelimiter2() {
    let type: MediaType = "video;"
    #expect(type.type == .video)
  }
  
  @Test func typeCasing() {
    let type: MediaType = "TeXt/plain"
    #expect(type.type == .text)
    #expect(type.type.rawValue == "text")
  }
  
  @Test func setType() {
    var type: MediaType = "text/plain"
    type.type = .example
    #expect(type == "example/plain")
  }
  
  // MARK: - Subtype
  
  @Test func subtype() {
    let type: MediaType = "text/plain"
    #expect(type.subtype == "plain")
  }
  
  @Test func noSubtype() {
    let type: MediaType = "text"
    #expect(type.subtype == nil)
  }
  
  @Test func subtypeWithTrailingDelimiter1() {
    let type: MediaType = "text/plain;"
    #expect(type.subtype == "plain")
  }
  
  @Test func subtypeWithTrailingDelimiter2() {
    let type: MediaType = "text/plain+"
    #expect(type.subtype == "plain")
  }
  
  @Test func subtypeCasing() {
    let type: MediaType = "text/SGML"
    #expect(type.subtype == "SGML")
  }
  
  @Test func addSubtype() {
    var type: MediaType = "text"
    type.subtype = "plain"
    #expect(type == "text/plain")
  }

  @Test func replaceSubtype() {
    var type: MediaType = "text/plain"
    type.subtype = "xml"
    #expect(type == "text/xml")
  }

  @Test func replaceSubtypeWithEmpty() {
    var type: MediaType = "text/plain"
    type.subtype = ""
    #expect(type == "text")
  }

  @Test func removeSubtype() {
    var type: MediaType = "text/plain"
    type.subtype = nil
    #expect(type == "text")
  }

  // MARK: - Facet
  
  @Test func facet() {
    let type: MediaType = "application/vnd.amazon.ebook"
    #expect(type.facet == "vnd")
  }
  
  @Test func noFacet() {
    let type: MediaType = "text/plain"
    #expect(type.facet == nil)
  }
  
  @Test func facetNoSubtype() {
    let type: MediaType = "text"
    #expect(type.facet == nil)
  }
  
  @Test func facetWithSubtypeWithMultiplePeriods() {
    let type: MediaType = "text/vnd.rtf.dir"
    #expect(type.subtype == "rtf.dir")
    #expect(type.facet == "vnd")
  }

  @Test func facetWithTrailingDelimiter1() {
    let type: MediaType = "application/vnd.amazon.ebook;"
    #expect(type.facet == "vnd")
  }
  
  @Test func facetWithTrailingDelimiter2() {
    let type: MediaType = "application/vnd.amazon.ebook+"
    #expect(type.facet == "vnd")
  }
  
  @Test func facetCasing() {
    let type: MediaType = "application/VND.amazon.ebook"
    #expect(type.facet == "VND")
  }
  
  @Test func addFacet() {
    var type: MediaType = "application/ebook"
    type.facet = "vnd"
    #expect(type == "application/vnd.ebook")
  }
  
  @Test func addEmptyFacet() {
    var type: MediaType = "application/ebook"
    type.facet = ""
    #expect(type == "application/ebook")
  }

  @Test func replaceFacet() {
    var type: MediaType = "application/vnd.ebook"
    type.facet = "rnd"
    #expect(type == "application/rnd.ebook")
  }

  @Test func replaceFacetWithEmpty() {
    var type: MediaType = "application/vnd.ebook"
    type.facet = ""
    #expect(type == "application/ebook")
  }

  @Test func removeFacet() {
    var type: MediaType = "application/vnd.ebook"
    type.facet = nil
    #expect(type == "application/ebook")
  }

  // MARK: - Tree
  
  @Test func tree() {
    let type: MediaType = "application/vnd.amazon.ebook"
    #expect(type.tree == .vendor)
  }
  
  @Test func noTree() {
    let type: MediaType = "text/plain"
    #expect(type.tree == .standards)
  }
  
  @Test func treeNoSubtype() {
    let type: MediaType = "text"
    #expect(type.tree == .standards)
  }
  
  @Test func treeWithSubtypeWithMultiplePeriods() {
    let type: MediaType = "text/vnd.rtf.dir"
    #expect(type.subtype == "rtf.dir")
    #expect(type.tree == .vendor)
  }

  @Test func treeWithTrailingDelimiter1() {
    let type: MediaType = "application/vnd.amazon.ebook;"
    #expect(type.tree == .vendor)
  }
  
  @Test func treeWithTrailingDelimiter2() {
    let type: MediaType = "application/vnd.amazon.ebook+"
    #expect(type.tree == .vendor)
  }
  
  @Test func treeCasing() {
    let type: MediaType = "application/VND.amazon.ebook"
    #expect(type.tree == .vendor)
  }
  
  // MARK: - Suffix
  
  @Test func suffix() {
    let type: MediaType = "application/epub+zip"
    #expect(type.suffix == "zip")
  }
  
  @Test func noSuffix() {
    let type: MediaType = "image/png"
    #expect(type.suffix == nil)
  }
  
  @Test func suffixForSubtypeWithMultiplePlusChars() {
    let type: MediaType = "image/jpeg+2000+q10"
    #expect(type.suffix == "q10")
  }

  @Test func suffixNoSubtype() {
    let type: MediaType = "image"
    #expect(type.suffix == nil)
  }
  
  @Test func suffixWithTrailingDelimiter() {
    let type: MediaType = "application/ld+json;"
    #expect(type.suffix == "json")
  }
  
  @Test func suffixCasing() {
    let type: MediaType = "application/ld+JSON"
    #expect(type.suffix == "JSON")
  }
  
  @Test func addSuffix() {
    var type: MediaType = "application/ld"
    type.suffix = "json"
    #expect(type == "application/ld+json")
  }
  
  @Test func addEmptySuffix() {
    var type: MediaType = "application/ld"
    type.suffix = ""
    #expect(type == "application/ld")
  }

  @Test func replaceSuffix() {
    var type: MediaType = "application/ld+xml"
    type.suffix = "json"
    #expect(type == "application/ld+json")
  }
  
  @Test func replaceSuffixWithEmpty() {
    var type: MediaType = "application/ld+xml"
    type.suffix = ""
    #expect(type == "application/ld")
  }

  @Test func removeSuffix() {
    var type: MediaType = "application/ld+json"
    type.suffix = nil
    #expect(type == "application/ld")
  }

  // MARK: - Parameters
  
  @Test func parameter() {
    let type: MediaType = "text/html; charset=UTF-8"
    #expect(type.parameters["charset"] == "UTF-8")
  }
  
  @Test func parameterWithQuotedValue() {
    let type: MediaType = "application/x-custom; q=\"abc def ghi\""
    #expect(type.parameters["q"] == "abc def ghi")
    #expect(
      MediaType(type: .application, subtype: "x-custom")
        .map(\.parameters) {
          $0.adding("abc def ghi", for: "q")
        } == "application/x-custom; q=\"abc def ghi\""
    )
  }
  
  @Test func parameterWithEscapedQuotes() {
    let type: MediaType = "application/x-custom; q=\"abc \\\"def\\\" ghi\""
    #expect(type.parameters["q"] == "abc \"def\" ghi")
  }

  @Test func noParameters() {
    let type: MediaType = "text/html"
    #expect(type.parameters["charset"] == nil)
  }
  
  @Test func missingParameters() {
    let type: MediaType = "text/html; charset=UTF-8"
    #expect(type.parameters["linebreak"] == nil)
  }

  @Test func multipleParameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    #expect(type.parameters["charset"] == "UTF-8")
    #expect(type.parameters["linebreak"] == "lf")
  }
  
  @Test func duplicateParameters() {
    let type: MediaType = "text/html; charset=UTF-8; charset=US-ASCII"
    #expect(type.parameters["charset"] == "UTF-8")
  }
  
  @Test func parametersWithTrailingDelimiter() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf;"
    #expect(type.parameters["charset"] == "UTF-8")
    #expect(type.parameters["linebreak"] == "lf")
  }
  
  @Test func parametersWithExtraneousDelimiters() {
    let type: MediaType = "text/html; charset=UTF-8;; linebreak=lf;;;"
    #expect(type.parameters["charset"] == "UTF-8")
    #expect(type.parameters["linebreak"] == "lf")
  }

  @Test func parameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"

    #expect(type.parameters == [
      MediaType.Parameter(name: "charset", value: "UTF-8"),
      MediaType.Parameter(name: "linebreak", value : "lf"),
    ])
  }

  @Test func parametersEmpty() {
    let type: MediaType = "text/html"
    #expect(type.parameters == [])
  }
  
  @Test func parametersWithSurroundingWhitespace() {
    let type: MediaType = "text/html; charset = UTF-8 ; linebreak = lf "
    #expect(type.parameters["charset"] == "UTF-8")
    #expect(type.parameters["linebreak"] == "lf")
    #expect(type.parameters == [
      MediaType.Parameter(name: "charset", value: "UTF-8"),
      MediaType.Parameter(name: "linebreak", value: "lf"),
    ])
  }
  
  // MARK: -
  
  @Test func addParameter() {
    var type: MediaType = "text/markdown"
    type.parameters["charset"] = "UTF-8"
    #expect(type == "text/markdown; charset=UTF-8")
  }
  
  @Test func addParameterCasing() {
    var type: MediaType = "text/markdown"
    type.parameters["CharSet"] = "UTF-8"
    #expect(type == "text/markdown; CharSet=UTF-8")
  }

  @Test func replaceParameter() {
    var type: MediaType = "text/markdown; charset=US-ASCII"
    type.parameters["charset"] = "UTF-8"
    #expect(type == "text/markdown; charset=UTF-8")
  }
  
  @Test func replaceParameterCasing() {
    var type: MediaType = "text/markdown; CHARSET=US-ASCII"
    type.parameters["CharSet"] = "UTF-8"
    #expect(type == "text/markdown; CharSet=UTF-8")
  }

  @Test func replaceParametersWithNone() {
    var type: MediaType = "text/markdown; charset=US-ASCII"
    type.parameters = .none
    #expect(type == "text/markdown")
  }

  // MARK: -
  
  @Test func removeParameter() {
    var type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    type.parameters.remove("charset")
    #expect(type == "text/html; linebreak=lf")
  }
  
  @Test func removeNonExistentParameter() {
    var type: MediaType = "text/html; charset=UTF-8"
    type.parameters.remove("linebreak")
    #expect(type == "text/html; charset=UTF-8")
  }

  @Test func removeParameters() {
    var type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    type.parameters.removeAll()
    #expect(type == "text/html")
  }
  
  @Test func removeNoParameters() {
    var type: MediaType = "text/html"
    type.parameters.removeAll()
    #expect(type == "text/html")
  }
  
  @Test func removeParameterCasing() {
    var type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    type.parameters.remove("CharSet")
    #expect(type == "text/html; linebreak=lf")
  }
  
  // MARK: - Mapping
  
  @Test func mapType() {
    var type: MediaType = "text/plain"
    type = type.map(\.type) {
      #expect($0 == "text")
      return "example"
    }
    #expect(type == "example/plain")
  }
  
  @Test func mapFacet() {
    var type: MediaType = "application/vnd.adobe.photoshop"
    type = type.map(\.facet) {
      #expect($0 == "vnd")
      return "x"
    }
    #expect(type == "application/x.adobe.photoshop")
  }
  
  @Test func mapNilFacet() {
    var type: MediaType = "application/ebook"
    type = type.map(\.facet) {
      #expect($0 == nil)
      return "x"
    }
    #expect(type == "application/x.ebook")
  }
  
  @Test func mapFacetToNil() {
    var type: MediaType = "application/vnd.ebook"
    type = type.map(\.facet) {
      #expect($0 == "vnd")
      return nil
    }
    #expect(type == "application/ebook")
  }
  
  @Test func mapSubtype() {
    var type: MediaType = "text/plain"
    type = type.map(\.subtype) {
      #expect($0 == "plain")
      return "html"
    }
    #expect(type == "text/html")
  }
  
  @Test func mapNilSubtype() {
    var type: MediaType = "text"
    type = type.map(\.subtype) {
      #expect($0 == nil)
      return "html"
    }
    #expect(type == "text/html")
  }
  
  @Test func mapSubtypeToNil() {
    var type: MediaType = "text/plain"
    type = type.map(\.subtype) {
      #expect($0 == "plain")
      return nil
    }
    #expect(type == "text")
  }
  
  @Test func mapSuffix() {
    var type: MediaType = "application/ld+json"
    type = type.map(\.suffix) {
      #expect($0 == "json")
      return "xml"
    }
    #expect(type == "application/ld+xml")
  }
  
  @Test func mapNilSuffix() {
    var type: MediaType = "application/ld"
    type = type.map(\.suffix) {
      #expect($0 == nil)
      return "xml"
    }
    #expect(type == "application/ld+xml")
  }
  
  @Test func mapSuffixToNil() {
    var type: MediaType = "application/ld+json"
    type = type.map(\.suffix) {
      #expect($0 == "json")
      return nil
    }
    #expect(type == "application/ld")
  }
  
  @Test func mapParameters() {
    var type: MediaType = "text/plain; charset=UTF-8"
    type = type.map(\.parameters) {
      #expect($0 == [ "charset" : "UTF-8" ])
      return $0.adding("ASCII", for: "charset")
    }
    #expect(type == "text/plain; charset=ASCII")
  }
  
  @Test func mapParametersToNone() {
    var type: MediaType = "text/plain; charset=UTF-8"
    type = type.map(\.parameters) {
      #expect($0 == [ "charset" : "UTF-8" ])
      return .none
    }
    #expect(type == "text/plain")
  }

  // MARK: - Replacement
  
  @Test func replacingType() {
    let type: MediaType = "text/plain"
    #expect(type.replacing(\.type, with: "example") == "example/plain")
  }

  @Test func replacingFacet() {
    let type: MediaType = "application/vnd.adobe.photoshop"
    #expect(type.replacing(\.facet, with: "x") == "application/x.adobe.photoshop")
  }
  
  @Test func replacingSubtype() {
    let type: MediaType = "text/plain"
    #expect(type.replacing(\.subtype, with: "html") == "text/html")
  }
  
  @Test func replacingSuffix() {
    let type: MediaType = "application/ld+json"
    #expect(type.replacing(\.suffix, with: "xml") == "application/ld+xml")
  }
  
  @Test func replacingParameters() {
    let type: MediaType = "text/plain; charset=UTF-8"
    #expect(type.replacing(\.parameters, with: .none) == "text/plain")
  }

  // MARK: - Normalization
  
  @Test func normalizedType() {
    let type = MediaType(type: .other("VIDEO"), subtype: "avi")
    #expect(type == "VIDEO/avi")
    #expect(type.normalized() == "video/avi")
  }
  
  @Test func normalizedSubtype() {
    let type = MediaType(type: .text, subtype: "SGML")
    #expect(type == "text/SGML")
    #expect(type.normalized() == "text/sgml")
  }

  @Test func normalizeSubtypeWhitespace() {
    let type: MediaType = " text / plain"
    #expect(type.normalized() == "text/plain")
  }

  @Test func normalizeFacet() {
    let type = MediaType(type: .application, facet: "VND", subtype: "adobe.photoshop")
    #expect(type == "application/VND.adobe.photoshop")
    #expect(type.normalized() == "application/vnd.adobe.photoshop")
  }
  
  @Test func normalizeSuffix() {
    let type = MediaType(type: .application, subtype: "ld", suffix: "JSON")
    #expect(type == "application/ld+JSON")
    #expect(type.normalized() == "application/ld+json")
  }
  
  @Test func normalizeParameterName() {
    let type = MediaType(type: .text, subtype: "plain", parameters: [ "CharSet" : "UTF-8" ])
    #expect(type == "text/plain; CharSet=UTF-8")
    #expect(type.normalized() == "text/plain; charset=UTF-8")
  }
  
  @Test func normalizeParameterOrder() {
    let type: MediaType = "text/plain; first=1st; second=2nd; third=3rd; fourth=4th; fifth=5th"
    #expect(type.normalized() == "text/plain; fifth=5th; first=1st; fourth=4th; second=2nd; third=3rd")
  }

  @Test func normalizeParameterWhitespace() {
    let type: MediaType = " text/plain ; charset = UTF-8 ; linebreak = lf "
    #expect(type.normalized() == "text/plain; charset=UTF-8; linebreak=lf")
  }
  
  @Test func normalizeParameterDelimiters() {
    let type: MediaType = "text/plain; charset = UTF-8; linebreak = lf;"
    #expect(type.normalized() == "text/plain; charset=UTF-8; linebreak=lf")
  }
  
  @Test func normalizeDuplicateParameters() {
    let type: MediaType = "text/plain; charset=UTF-8; charset=US-ASCII; charset: ISO-8859-1"
    let normalized = type.normalized()
    print("\(normalized)")
    #expect(type.normalized() == "text/plain; charset=UTF-8")
  }
  
  @Test func normalizeCharset() {
    let type: MediaType = "text/plain; charset=utf-8"
    #expect(type.normalized() == "text/plain; charset=UTF-8")
  }
  
  @Test func normalizeUnknownCharset() {
    let type: MediaType = "text/plain; charset=unknown"
    #expect(type.normalized() == "text/plain; charset=unknown")
  }
  
  @Test func normalizeCharsetToPreferredName() {
    let type: MediaType = "text/plain; charset=ISO_8859-1:1987"
    #expect(type.normalized() == "text/plain; charset=ISO-8859-1")
  }
  
  @Test func normalizeMarkdownVariant() {
    let type: MediaType = "text/markdown; variant=commonmark"
    #expect(type.normalized() == "text/markdown; variant=CommonMark")
  }
  
  @Test func normalizeUnknownMarkdownVariant() {
    let type: MediaType = "text/markdown; variant=unknown"
    #expect(type.normalized() == "text/markdown; variant=unknown")
  }

  // MARK: - Subtype Factory Methods
  
  @Test func applicationSubtype() {
    let type: MediaType = .application(.pkcs8)
    #expect(type.rawValue == "application/pkcs8")
  }
  
  @Test func audioSubtype() {
    let type: MediaType = .audio(.mpeg)
    #expect(type.rawValue == "audio/mpeg")
  }
  
  @Test func fontSubtype() {
    let type: MediaType = .font(.otf)
    #expect(type.rawValue == "font/otf")
  }
  
  @Test func imageSubtype() {
    let type: MediaType = .image(.png)
    #expect(type.rawValue == "image/png")
  }
  
  @Test func messageSubtype() {
    let type: MediaType = .message(.http)
    #expect(type.rawValue == "message/http")
  }
  
  @Test func modelSubtype() {
    let type: MediaType = .model(.obj)
    #expect(type.rawValue == "model/obj")
  }
  
  @Test func multipartSubtype() {
    let type: MediaType = .multipart(.digest)
    #expect(type.rawValue == "multipart/digest")
  }
  
  @Test func textSubtype() {
    let type: MediaType = .text(.css)
    #expect(type.rawValue == "text/css")
  }
  
  @Test func videoSubtype() {
    let type: MediaType = .video(.h264)
    #expect(type.rawValue == "video/H264")
  }
  
  // MARK: - Coding
  
  @Test func encoding() throws {
    let encoder = JSONEncoder()
    let type: MediaType = .application(.json)
    
    let output = try encoder.encode(type)
    let string = String(bytes: output, encoding: .utf8)!
    
    #expect(string == #""application\/json""#)
  }
  
  @Test func decoding() throws {
    let decoder = JSONDecoder()
    let input = #""application\/json""#.data(using: .utf8)!
    
    let type = try decoder.decode(MediaType.self, from: input)
    #expect(type == .application(.json))
  }
  
  // MARK: - Markdown
  
  @Test func markdownVariant() {
    #expect(MediaType.text(.markdown) == "text/markdown")
    #expect(
      MediaType.text(.markdown)
        .map(\.parameters) {
          $0.adding(.markdownVariant(.commonMark))
        } == "text/markdown; variant=CommonMark"
    )
  }
  
  @Test func setMarkdownVariant() {
    #expect(
      MediaType("text/markdown")
        .parameters
        .markdownVariant == nil
    )
    #expect(
      MediaType("text/markdown; variant=CommonMark")
        .parameters
        .markdownVariant == .commonMark
    )
    #expect(
      MediaType("text/markdown; variant=unknown")
        .parameters
        .markdownVariant == nil
    )
  }
  
  // MARK: - Matching
  
  @Test func matchesTopLevelType() {
    #expect(MediaType("text/plain").matches("text") == true)
    #expect(MediaType("text/plain").matches("image") == false)
    #expect(MediaType("text").matches("text/plain") == false)
    #expect(MediaType("TEXT/PLAIN").matches("text") == true)
  }
  
  @Test func matchesFacet() {
    #expect(MediaType("application/vnd.oasis.opendocument.chart").matches("application/vnd.oasis.opendocument.chart") == true)
    #expect(MediaType("application/vnd.oasis.opendocument.chart").matches("application/x.oasis.opendocument.chart") == false)
    #expect(MediaType("Application/VND.Oasis.OpenDocument.Chart").matches("application/vnd.oasis.opendocument.chart") == true)
    #expect(MediaType("application/vnd.oasis.opendocument.chart").matches("application/vnd.oasis.opendocument.chart") == true)
  }

  @Test func matchesSubtype() {
    #expect(MediaType("text/plain").matches("text/plain") == true)
    #expect(MediaType("text/plain").matches("text/html") == false)
    #expect(MediaType("text/html").matches("application/html") == false)
    #expect(MediaType("text/PLAIN").matches("text/plain") == true)
  }

  @Test func matchesSuffix() {
    #expect(MediaType("application/soap+xml").matches("application/soap+xml") == true)
    #expect(MediaType("application/soap+xml").matches("application/soap") == true)
    #expect(MediaType("application/soap+xml").matches("application/soap+json") == false)
    #expect(MediaType("application/soap+xml").matches("application/soap+XML") == true)
  }

  @Test func matchesParameters() {
    #expect(MediaType("text/plain; charset=UTF-8").matches("text/plain") == true)
    #expect(MediaType("text/plain; charset=UTF-8").matches("text/plain; charset=UTF-8") == true)
    #expect(MediaType("text/plain; charset=UTF-8").matches("text/plain; charset=UTF-16") == false)
    #expect(MediaType("text/plain").matches("text/plain; charset=UTF-8") == false)

    #expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown") == true)
    #expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-8") == true)
    #expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=utf-8") == true)
    #expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-8; variant=CommonMark") == true)
    #expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-8; variant=commonmark") == true)
    #expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-16") == false)
    #expect(MediaType("text/markdown; charset=UTF-8; variant=CommonMark").matches("text/markdown; charset=UTF-8; variant=pandoc") == false)
  }
  
  // MARK: - Charset
  
  @Test func charset() {
    #expect(
      MediaType("text/plain")
        .parameters
        .charset == nil
    )
    #expect(
      MediaType("text/plain; charset=UTF-8")
        .parameters
        .charset == .utf8
    )
    #expect(
      MediaType("text/plain; charset=utf-8")
        .parameters
        .charset == .utf8
    )
  }
  
  @Test func setCharset() {
    let type = MediaType("text/plain")
      .map(\.parameters) {
        $0.adding(.charset(.utf8))
      }
    #expect(type == "text/plain; charset=UTF-8")
  }
  
  // MARK: - Codecs
  
  @Test func codecsSingle() {
    let type: MediaType = .audio(.mp4)
      .map(\.parameters) {
        $0.adding(.codecs([ "mp4a.40.2" ]))
      }
    #expect(type == "audio/mp4; codecs=mp4a.40.2")
    #expect(
      MediaType(rawValue: "audio/mp4; codecs=mp4a.40.2")!
        .parameters
        .codecs == [
          "mp4a.40.2"
        ]
    )
  }
  
  @Test func codecsMultiple() {
    let type: MediaType = .audio(.mp4)
      .map(\.parameters) {
        $0.adding(.codecs([
          "avc1.42E01E",
          "mp4a.40.2",
        ]))
      }
    #expect(type == "audio/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"")
    #expect(
      MediaType(rawValue: "audio/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"")!
        .parameters
        .codecs == [
          "avc1.42E01E",
          "mp4a.40.2"
        ]
    )
  }
}
