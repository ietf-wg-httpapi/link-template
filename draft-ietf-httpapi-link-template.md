---
title: "The Link-Template HTTP Header Field"
abbrev: "Link-Template"
category: std

docname: draft-ietf-httpapi-link-template-latest
v: 3
area: "Applications and Real-Time"
workgroup: "Building Blocks for HTTP APIs"
ipr: trust200902

keyword: Link
keyword: Linking
keyword: Web Linking
keyword: link relation

venue:
  group: "Building Blocks for HTTP APIs"
  type: "Working Group"
  mail: "httpapi@ietf.org"
  arch: "https://mailarchive.ietf.org/arch/browse/httpapi/"
  github: "ietf-wg-httpapi/link-template"
  latest: "https://ietf-wg-httpapi.github.io/link-template/draft-ietf-httpapi-link-template.html"

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Prahran
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  HTTP: RFC9110
  URI-TEMPLATE: RFC6570
  URI: RFC3986
  WEB-LINKING: RFC8288
  STRUCTURED-FIELDS: RFC8941


--- abstract

This specification defines the Link-Template HTTP header field, providing a means for describing the structure of a link between two resources, so that new links can be generated.


--- middle


# Introduction

{{URI-TEMPLATE}} defines a syntax for templates that, when expanded using a set of variables, results in a URI {{URI}}.

This specification defines a HTTP header field {{HTTP}} for conveying templates for links in the headers of a HTTP message. It is complimentary to the Link header field defined in {{Section 3 of WEB-LINKING}}, which carries links directly.

## Notational Conventions

{::boilerplate bcp14-tagged}

This specification uses the following terms from {{STRUCTURED-FIELDS}}: List, String, Parameter.


# The Link-Template Header Field

The Link-Template header field is a Structured Field {{STRUCTURED-FIELDS}} that serializes one or more links into HTTP message metadata. It is semantically equivalent to the Link header field defined in {{Section 3 of WEB-LINKING}}, except that it uses URI Templates {{URI-TEMPLATE}} to convey the structure of links.

Its value is a List of Strings. Each String is a URI Template, and Parameters on it carry associated metadata.

For example:

~~~ http-message
Link-Template: "/{username}"; rel="item"
~~~

indicates that a resource with the relation type "item" can be found by expanding the "username" variable into the template given.

The link target (as defined in {{Section 2 of WEB-LINKING}}) is the result of expanding the URI Template {{URI-TEMPLATE}} (being converted to an absolute URI after expansion, if necessary).

The link context and link relation type for the link (as defined in {{Section 2 of WEB-LINKING}}) are conveyed using the "anchor" and "rel" Parameters, as they are for the Link header field in {{Section 3 of WEB-LINKING}}. Their values MUST be Strings.

However, the "anchor" Parameter MAY contain a URI Template. For example:

~~~ http-message
Link-Template: "/books/{book_id}/author";
               rel="author"; anchor="#{book_id}"
~~~

Here, the link to the author for a particular book in a list of books can be found by following the link template.

This specification defines additional semantics for the "var-base" Parameter on templated links; see below.

The link's target attributes (as defined in {{Section 2.2 of WEB-LINKING}}) are conveyed using other Parameters, in a manner similar to the Link header field. These Parameter values MUST be Strings. Note that some target attribute names will not serialise as Structure Field Parameter keys (see {{Section 3.1.2 of STRUCTURED-FIELDS}}).

Implementations MUST support all levels of template defined by {{URI-TEMPLATE}} in the link String and the anchor Parameter.


## The 'var-base' parameter

When a templated link has a 'var-base' parameter, its value conveys a URI-reference that is used as a base URI for the variable names in the URI template. This allows template variables to be globally identified, rather than specific to the context of use.

Dereferencing the URI for a particular variable might lead to more information about the syntax or semantics of that variable; specification of particular formats for this information is out of scope for this document.

To determine the URI for a given variable, the value given is used as a base URI in reference resolution (as specified in {{URI}}). If the resulting URI is still relative, the context of the link is used as the base URI in a further resolution; see {{WEB-LINKING}}.

For example:

~~~ http-message
Link-Template: "/widgets/{widget_id}";
               rel="https://example.org/rel/widget";
               var-base="https://example.org/vars/"
~~~

indicates that a resource with the relation type "https://example.org/rel/widget" can be found by expanding the "https://example.org/vars/widget_id" variable into the template given.

If the current context of the message that the header appears within is "https://example.org/", the same information could be conveyed by this header field:

~~~ http-message
Link-Template: "/widgets/{widget_id}";
               rel="https://example.org/rel/widget";
               var-base="/vars/"
~~~


# Security Considerations

The security consideration for the Link header field in {{WEB-LINKING}} and those for URI Templates {{URI-TEMPLATE}} both apply.

# IANA Considerations

This specification enters the "Link-Template" into the Hypertext Transfer Protocol (HTTP) Field Name Registry.

* Field Name: Link-Template
* Status: permanent
* Specification document: [this document]


--- back
