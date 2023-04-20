# Ordered Property List Encoder for Swift

[![Build](https://github.com/fwcd/swift-ordered-plist-encoder/actions/workflows/build.yml/badge.svg)](https://github.com/fwcd/swift-ordered-plist-encoder/actions/workflows/build.yml)

A custom XML property list encoder for Swift that encodes keys in the same order as they were declared, primarily intended for interoperability with legacy formats.

## Background

While the validity of a dictionary from a property list, like an object in JSON, ideally should be unaffected by the order of its keys, some plist-based formats such as the iTunes library XML format have implementations/parsers that depend on keys being 'conveniently' ordered (e.g. the id of the parent playlist is listed before the children). `PropertyListEncoder` from `Foundation` unfortunately does not offer this, hence this package.
