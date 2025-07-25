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
  public struct ApplicationSubtype: Subtype {
    public let rawValue: String
    
    public init?(rawValue: String) {
      let rawValue = rawValue.trimmed()
      guard !rawValue.isEmpty else { return nil }
      self.rawValue = rawValue
    }
  }
}

// MARK: -

extension MediaType.ApplicationSubtype {
  public static let appleInstallerPackage: Self = "vnd.apple.installer+xml"
  public static let appleKeynote: Self = "vnd.apple.keynote"
  public static let appleKeynoteSFF: Self = "x-iwork-keynote-sffkey"
  public static let appleNumbers: Self = "vnd.apple.numbers"
  public static let appleNumbersSFF: Self = "x-iwork-numbers-sffnumbers"
  public static let applePages: Self = "vnd.apple.pages"
  public static let applePagesSFF: Self = "x-iwork-pages-sffpages"
  public static let bzipArchive: Self = "x-bzip"
  public static let bzip2Archive: Self = "x-bzip2"
  public static let cshellScript: Self = "x-csh"
  public static let dns: Self = "dns"
  public static let dnsJSON: Self = "dns+json"
  public static let dnsMessage: Self = "dns-message"
  public static let ecmascript: Self = "ecmascript"
  public static let epubBook: Self = "epub+zip"
  public static let gzip: Self = "gzip"
  public static let http: Self = "http"
  public static let javaArchive: Self = "java-archive"
  public static let javascript: Self = "javascript"
  public static let json: Self = "json"
  public static let jsonLD: Self = "ld+json"
  public static let microsoftEmbeddedFont: Self = "vnd.ms-fontobject"
  public static let microsoftExcel: Self = "vnd.ms-excel"
  public static let microsoftExcelXML: Self = "vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  public static let microsoftPowerpoint: Self = "vnd.ms-powerpoint"
  public static let microsoftPowerpointXML: Self = "vnd.openxmlformats-officedocument.presentationml.presentation"
  public static let microsoftProject: Self = "vnd.ms-project"
  public static let microsoftWord: Self = "msword"
  public static let microsoftWordXML: Self = "vnd.openxmlformats-officedocument.wordprocessingml.document"
  public static let octetStream: Self = "octet-stream"
  public static let ogg: Self = "ogg"
  public static let openDocumentChart: Self = "vnd.oasis.opendocument.chart"
  public static let openDocumentDatabase: Self = "vnd.oasis.opendocument.database"
  public static let openDocumentFormula: Self = "vnd.oasis.opendocument.formula"
  public static let openDocumentGraphics: Self = "vnd.oasis.opendocument.graphics"
  public static let openDocumentImage: Self = "vnd.oasis.opendocument.image"
  public static let openDocumentPresentation: Self = "vnd.oasis.opendocument.presentation"
  public static let openDocumentSpreadsheet: Self = "vnd.oasis.opendocument.spreadsheet"
  public static let openDocumentText: Self = "vnd.oasis.opendocument.text"
  public static let pdf: Self = "pdf"
  public static let pgpEncrypted: Self = "pgp-encrypted"
  public static let pgpKeys: Self = "pgp-keys"
  public static let pgpSignature: Self = "pgp-signature"
  public static let pkcs10: Self = "pkcs10"
  public static let pkcs7MIME: Self = "pkcs7-mime"
  public static let pkcs7Signature: Self = "pkcs7-signature"
  public static let pkcs8: Self = "pkcs8"
  public static let pkcs8Encrypted: Self = "pkcs8-encrypted"
  public static let pkcs12: Self = "pkcs12"
  public static let postscript: Self = "postscript"
  public static let quarkXPress: Self = "vnd.Quark.QuarkXPress"
  public static let rar: Self = "vnd.rar"
  public static let rarCompressed: Self = "x-rar-compressed"
  public static let restfulJSON: Self = "vnd.restful+json"
  public static let rtf: Self = "rtf"
  public static let sgml: Self = "SGML"
  public static let soapXML: Self = "soap+xml"
  public static let sql: Self = "sql"
  public static let tar: Self = "application/x-tar"
  public static let vcardJSON: Self = "vcard+json"
  public static let vcardXML: Self = "vcard+xml"
  public static let visio: Self = "vnd.visio"
  public static let wsdlXML: Self = "wsdl+xml"
  public static let xml: Self = "xml"
  public static let xmlDTD: Self = "xml-dtd"
  public static let xsltXML: Self = "xslt+xml"
  public static let zip: Self = "zip"
  public static let zlib: Self = "zlib"
}

// MARK: -

extension MediaType {

  /// Returns an application media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An application subtype.
  public static func application(_ subtype: ApplicationSubtype) -> Self {
    return Self(type: "application", subtype: subtype.rawValue)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `application` top-level type. The media type does not
  /// have a sub-type.
  public static let application = Self(type: .application)
}
