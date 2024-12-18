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
  public enum ApplicationSubtype: String, Hashable, Sendable {
    case appleInstallerPackage = "vnd.apple.installer+xml"
    case appleKeynote = "vnd.apple.keynote"
    case appleNumbers = "vnd.apple.numbers"
    case applePages = "vnd.apple.pages"
    case bzipArchive = "x-bzip"
    case bzip2Archive = "x-bzip2"
    case cshellScript = "x-csh"
    case dns = "dns"
    case dnsJSON = "dns+json"
    case dnsMessage = "dns-message"
    case ecmascript = "ecmascript"
    case epubBook = "epub+zip"
    case gzip = "gzip"
    case http = "http"
    case javaArchive = "java-archive"
    case javascript = "javascript"
    case json = "json"
    case jsonLD = "ld+json"
    case microsoftWord = "msword"
    case microsoftWordXML = "vnd.openxmlformats-officedocument.wordprocessingml.document"
    case microsoftEmbeddedFont = "vnd.ms-fontobject"
    case microsoftExcel = "vnd.ms-excel"
    case microsoftPowerpoint = "vnd.ms-powerpoint"
    case microsoftProject = "vnd.ms-project"
    case octetStream = "octet-stream"
    case ogg = "ogg"
    case openDocumentChart = "vnd.oasis.opendocument.chart"
    case openDocumentDatabase = "vnd.oasis.opendocument.database"
    case openDocumentFormula = "vnd.oasis.opendocument.formula"
    case openDocumentGraphics = "vnd.oasis.opendocument.graphics"
    case openDocumentImage = "vnd.oasis.opendocument.image"
    case openDocumentPresentation = "vnd.oasis.opendocument.presentation"
    case openDocumentSpreadsheet = "vnd.oasis.opendocument.spreadsheet"
    case openDocumentText = "vnd.oasis.opendocument.text"
    case pdf = "pdf"
    case pgpEncrypted = "pgp-encrypted"
    case pgpKeys = "pgp-keys"
    case pgpSignature = "pgp-signature"
    case pkcs10 = "pkcs10"
    case pkcs7MIME = "pkcs7-mime"
    case pkcs7Signature = "pkcs7-signature"
    case pkcs8 = "pkcs8"
    case pkcs8Encrypted = "pkcs8-encrypted"
    case pkcs12 = "pkcs12"
    case postscript = "postscript"
    case quarkXPress = "vnd.Quark.QuarkXPress"
    case rar = "vnd.rar"
    case rarCompressed = "x-rar-compressed"
    case restfulJSON = "vnd.restful+json"
    case rtf = "rtf"
    case sgml = "SGML"
    case soapXML = "soap+xml"
    case sql = "sql"
    case tar = "application/x-tar"
    case vcardJSON = "vcard+json"
    case vcardXML = "vcard+xml"
    case visio = "vnd.visio"
    case wsdlXML = "wsdl+xml"
    case xml = "xml"
    case xmlDTD = "xml-dtd"
    case xsltXML = "xslt+xml"
    case zip = "zip"
    case zlib = "zlib"
  }
}

// MARK: -

extension MediaType {

  /// Returns an application media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An application subtype.
  public static func application(_ subtype: ApplicationSubtype) -> Self {
    return application(subtype.rawValue)
  }

  /// Returns an application media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An application subtype string.
  public static func application(_ subtype: String) -> Self {
    return Self(type: "application", subtype: subtype)
  }
}

// MARK: -

extension MediaType {
  
  /// Media type for the `application` top-level type. The media type does not
  /// have a sub-type.
  public static let application = Self(type: .application)
}
