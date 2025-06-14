# MediaType

![](https://img.shields.io/badge/License-MIT-informational?style=flat)
![](https://img.shields.io/badge/Unit%20Tests-Passed-success?style=flat)
![](https://img.shields.io/badge/Swift-6.0+-red?style=flat)
![](https://img.shields.io/badge/SPM-Package-red?style=flat)
![](https://img.shields.io/badge/iOS-grey?style=flat&logo=apple&logoColor=white)
![](https://img.shields.io/badge/macOS-grey?style=flat&logo=apple&logoColor=white)

MediaType is a Swift package for iOS, iPadOS, watchOS, tvOS and macOS that implements media type parsing and formatting consistent with IETF RFC 6838 ([Media Type Specifications and Registration Procedures](https://tools.ietf.org/html/rfc6838)).

***

# Usage

The MediaType package defines the `MediaType` value type that is used to represent a media type string, e.g.

```swift
import MediaType

var type = MediaType("application/ld")

type = type.adding(suffix: "json")
type = type.adding(parameter: "charset", value: "UTF-8")

if type.rawValue == "application/ld+json; charset=UTF-8" {
}
```

# Why Use MediaType?

Why use the `MediaType` type rather than a simple `String`?

### Ease-of-use

A media type's contents can be easily inspected.

### Expressiveness

Declaring a variable as `MediaType` is more expressive than `String`, better communicating the intent of the variable.

### Type-safety

Declaring a variable as `MediaType` reduces the likelihood that non-media type strings will be inadvertently passed as or assigned to it.

### Case-sensitivity

The `normalized()` method (see below) can be used to ensure that media types are correctly interpreted and compared.

### Correctness

Avoid typos by using the subtype factory methods to create media type instances for common types.

# Pre-Defined Media Types

`MediaType` declares factory methods for each of the IANA-defined top-level types enabling media types to be created with expressions such as

```swift
static let json: MediaType = .application(.json)
```

Enumerated constants are defined for over **130 well-known media types** such as `application/json`, `image/gif`, `text/html` and many more.

# Components

A media type's various components (`type`, `subtype`, `facet`, `suffix` and `parameters`) can be inspected using properties.

The registration tree can be determined using the `tree` property:

```swift
switch contentType.tree {
  case .standards:
    ...
  case .vendor:
    ...
  case .personal:
    ...
  case .unregistered:
    ...
  case .other(let facet):
    ...
}
```

# String Literals

`MediaType` adopts `ExpressibleByStringLiteral` allow for expressions such as:

```swift
let contentType: MediaType = ...

if contentType == "text/plain" {
}
```

# Parameters

A media type may include parameters such as `text/plain; charset=UTF-8`.

A single parameter's value can be accessed using the subscript, e.g.

```swift
let contentType = ...

if contentType["charset"] == "UTF-8" {
}
```

A media type's parameters can be enumerated using the `forEach(_:)` method:

```swift
let contentType = ...

contentType.forEach {
  if $0 == "charset" {
    ...
  }
}
```

The `parameters` property can be used to obtain a dictionary of the media type's parameters:

```swift
let contentType = ...

for parameter in contentType.parameters {
  print("name: \(parameter.key)")
  print("value: \(parameter.value)")
}
```

A parameter can be added through use of the `adding(parameter:, value:)` method:

```swift
let contentType = MediaType("text/plain").adding("UTF-8", for: "charset")
```

A media type's parameters can be removed using the `removingParameters()` method:

```swift
let contentType = MediaType("text/plain; charset=UTF-8")
...
if contentType.removingParameters() == "text/plain" {
}
```

# Comparison

## Case Handling

Several, but not all of the components of a media type should be handled in a case-insensitive manner. For example, the type, subtype, facet and suffix components are case-insensitive, as are parameter names, whereas parameter values are not.

This makes comparing media types difficult as a case-insensitive comparison of two media type strings fails to take the case-sensitive nature of parameter values into account.

`MediaType` is case-preserving, retaining the case of the input provided. Two `MediaType` instances that differ by case will therefore not compare the same.

## Normalization

The `normalized()` method returns a media type that has been transformed as follows:

- The type, subtype, facet and suffix components are converted to lower case
- The names of all parameters are converted to lower case
- Extraneous whitespace is removed
- Duplicate parameters are removed
- Parameters are sorted into alphanumeric order.

Two normalized media types can therefore be reliably compared, e.g.

```swift
static let json = MediaType("application/json").normalized()

...

if contentType.normalized() == json {
  ...
}
```

## Matching

`MediaType` provides the `matches(_:)` method that can be used to determine whether a media type matches a template type, e.g.

```swift
let type: MediaType = "text/html; charset=UTF-8"

if type.matches(.text(.html)) {
  ...
}
```

A media type can also be matched against a top-level type:

```swift
let type: MediaType = "text/plain"

if type.matches(.text) {
  ...
}
```

as well as a template without a suffix:

```swift
let type: MediaType = "application/ld+json"

if type.matches("application/ld") {
  ...
}
```

The `~=` operator can also be used to perform the above matches, e.g.

```swift
let type: MediaType = "text/html; charset=UTF-8"

if type ~= .text {
  ...
}
```

## UTType

Extensions are provided for `UTType` (available on iOS >= 14, tvOS >= 14, macOS >= 11 and watchOS >= 7) that simplify conversion to and from a `MediaType`, e.g.

```swift
let type = UTType(mediaType: .text(.html))
```

and

```swift
let type: UTType = .utfPlainText

if type.preferredMediaType == .text(.plain).charset(.utf8) {
  ...
}
```

### Charset Mapping

This initializer extends the built-in `init(mimeType:, conformingTo:)` to map plain-text media types with a `charset` of UTF-8 to `public.utf8-plain-text` and UTF-16, UTF-16LE and UTF-16BE to `public.utf16-plain-text`.
