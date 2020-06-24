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

import XCTest
@testable import MediaType

class MediaTypeTests: XCTestCase {
  
  // MARK: - RawRepresentable
  
  func testRawValue() {
    let type = MediaType(rawValue: "text/plain")
    XCTAssertNotNil(type)
    XCTAssertEqual(type!.rawValue, "text/plain")
  }
  
  func testRawValueEmpty() {
    let type = MediaType(rawValue: "")
    XCTAssertNil(type)
  }
  
  // MARK: - Initialization
  
  func testInitializeType() {
    let type = MediaType(type: .text)
    XCTAssertEqual(type.rawValue, "text")
  }
  
  func testInitializeSubtype() {
    let type = MediaType(type: .text, subtype: "plain")
    XCTAssertEqual(type.rawValue, "text/plain")
  }
  
  func testInitializeTree() {
    let type = MediaType(type: .audio, tree: .vendor, subtype: "dolby.pl2")
    XCTAssertEqual(type.rawValue, "audio/vnd.dolby.pl2")
  }
  
  func testInitializeSuffix() {
    let type = MediaType(type: .application, subtype: "atom", suffix: "xml")
    XCTAssertEqual(type.rawValue, "application/atom+xml")
  }
  
  func testInitializeTreeAndSuffix() {
    let type = MediaType(type: .application, tree: .vendor, subtype: "3gpp.bsf", suffix: "xml")
    XCTAssertEqual(type.rawValue, "application/vnd.3gpp.bsf+xml")
  }
  
  func testInitializeParameters() {
    let type = MediaType(type: .text, subtype: "html", parameters: [ "charset" : "UTF-8" ])
    XCTAssertEqual(type.rawValue, "text/html; charset=UTF-8")
  }
  
  func testInitializeEmptyParameters() {
    let type = MediaType(type: .text, subtype: "html", parameters: [:])
    XCTAssertEqual(type.rawValue, "text/html")
  }
  
  // MARK: - Type
  
  func testType() {
    let type: MediaType = "text/plain"
    XCTAssertEqual(type.type, .text)
  }
  
  func testTypeOnly() {
    let type: MediaType = "image"
    XCTAssertEqual(type.type, .image)
  }
  
  func testTypeWithTrailingDelimiter1() {
    let type: MediaType = "video/"
    XCTAssertEqual(type.type, .video)
  }
  
  func testTypeWithTrailingDelimiter2() {
    let type: MediaType = "video;"
    XCTAssertEqual(type.type, .video)
  }
  
  func testTypeCasing() {
    let type: MediaType = "TeXt/plain"
    XCTAssertEqual(type.type, .text)
    XCTAssertEqual(type.type.rawValue, "text")
  }
  
  // MARK: - Subtype
  
  func testSubtype() {
    let type: MediaType = "text/plain"
    XCTAssertEqual(type.subtype, "plain")
  }
  
  func testNoSubtype() {
    let type: MediaType = "text"
    XCTAssertNil(type.subtype)
  }
  
  func testSubtypeWithTrailingDelimiter1() {
    let type: MediaType = "text/plain;"
    XCTAssertEqual(type.subtype, "plain")
  }
  
  func testSubtypeWithTrailingDelimiter2() {
    let type: MediaType = "text/plain+"
    XCTAssertEqual(type.subtype, "plain")
  }
  
  func testSubtypeCasing() {
    let type: MediaType = "text/SGML"
    XCTAssertEqual(type.subtype, "SGML")
  }
  
  // MARK: - Subtree
  
  func testTree() {
    let type: MediaType = "application/vnd.amazon.ebook"
    XCTAssertEqual(type.tree, .vendor)
  }
  
  func testNoTree() {
    let type: MediaType = "text/plain"
    XCTAssertEqual(type.tree, .standards)
  }
  
  func testTreeNoSubtype() {
    let type: MediaType = "text"
    XCTAssertNil(type.tree)
  }
  
  func testTreeWithSubtypeWithMultiplePeriods() {
    let type: MediaType = "text/vnd.rtf.dir"
    XCTAssertEqual(type.subtype, "rtf.dir")
    XCTAssertEqual(type.tree, .vendor)
  }

  func testTreeWithTrailingDelimiter1() {
    let type: MediaType = "application/vnd.amazon.ebook;"
    XCTAssertEqual(type.tree, .vendor)
  }
  
  func testTreeWithTrailingDelimiter2() {
    let type: MediaType = "application/vnd.amazon.ebook+"
    XCTAssertEqual(type.tree, .vendor)
  }
  
  func testTreeCasing() {
    let type: MediaType = "application/VND.amazon.ebook"
    XCTAssertEqual(type.tree, .vendor)
    XCTAssertEqual(type.tree?.rawValue, "vnd")
  }
  
  // MARK: - Suffix
  
  func testSuffix() {
    let type: MediaType = "application/epub+zip"
    XCTAssertEqual(type.suffix, "zip")
  }
  
  func testNoSuffix() {
    let type: MediaType = "image/png"
    XCTAssertNil(type.suffix)
  }
  
  func testSuffixForSubtypeWithMultiplePlusChars() {
    let type: MediaType = "image/jpeg+2000+q10"
    XCTAssertEqual(type.suffix, "q10")
  }

  func testSuffixNoSubtype() {
    let type: MediaType = "image"
    XCTAssertNil(type.suffix)
  }
  
  func testSuffixWithTrailingDelimiter() {
    let type: MediaType = "application/ld+json;"
    XCTAssertEqual(type.suffix, "json")
  }
  
  func testSuffixCasing() {
    let type: MediaType = "application/ld+JSON"
    XCTAssertEqual(type.suffix, "JSON")
  }
  
  // MARK: - Parameters
  
  func testParameter() {
    let type: MediaType = "text/html; charset=UTF-8"
    XCTAssertEqual(type["charset"], "UTF-8")
  }
  
  func testNoParameters() {
    let type: MediaType = "text/html"
    XCTAssertNil(type["charset"])
  }
  
  func testMissingParameters() {
    let type: MediaType = "text/html; charset=UTF-8"
    XCTAssertNil(type["linebreak"])
  }

  func testMultipleParameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf"
    XCTAssertEqual(type["charset"], "UTF-8")
    XCTAssertEqual(type["linebreak"], "lf")
  }
  
  func testDuplicateParameters() {
    let type: MediaType = "text/html; charset=UTF-8; charset=US-ASCII"
    XCTAssertEqual(type["charset"], "UTF-8")
  }
  
  func testParametersWithTrailingDelimiter() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf;"
    XCTAssertEqual(type["charset"], "UTF-8")
    XCTAssertEqual(type["linebreak"], "lf")
  }
  
  func testParameters() {
    let type: MediaType = "text/html; charset=UTF-8; linebreak=lf;"
    let expected = [
      "charset" : "UTF-8",
      "linebreak" : "lf",
    ]
    XCTAssertEqual(type.parameters, expected)
  }

  func testParametersEmpty() {
    let type: MediaType = "text/html"
    XCTAssertEqual(type.parameters, [:])
  }
  
  func testParametersWithSurroundingWhitespace() {
    let type: MediaType = "text/html; charset = UTF-8 ; linebreak = lf "
    XCTAssertEqual(type["charset"], "UTF-8")
    XCTAssertEqual(type["linebreak"], "lf")
    let expected = [
      "charset" : "UTF-8",
      "linebreak" : "lf",
    ]
    XCTAssertEqual(type.parameters, expected)
  }
}
