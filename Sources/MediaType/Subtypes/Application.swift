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

public enum ApplicationSubtype: String {
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

// MARK: -

extension MediaType {

  /// Returns an application media type with the specified subtype.
  ///
  /// - parameters:
  ///   - subtype: An application subtype.
  public static func application(_ subtype: ApplicationSubtype) -> MediaType {
    return application(subtype.rawValue)
  }

  /// Returns an application media type with the specified subtype string.
  ///
  /// - parameters:
  ///   - subtype: An application subtype string.
  public static func application(_ subtype: String) -> MediaType {
    return MediaType(type: "application", subtype: subtype)
  }
}
