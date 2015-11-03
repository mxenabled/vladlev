Vladlev
===========

An implementation of the levenshtein distance algorithm for ruby using FFI

## Installation

Add this line to your gemfile and then run `bundle` to install

    gem 'vladlev'

## Usage

Vladlev will calculate the levenshtein distance between two strings.  The levenshtein distance is the number of transforms necessary to transform one string to be idential to the other.  A transform is defined as an addition, deletion, or alteration of a single character in a string.

In order to calculate the distance

    Vladlev.distance("string1", "string2")
    >> 1

Vladlev also includes a 3 parameter version of the distance method.  The third parameter is "maximum distance", which tells Vladlev to stop calculation once the distance becomes greater than this parameter.

In order to use this optimization
  
    Vladlev.distance("string1234567890", "string1", 1)
    >> 16

    Vladlev.distance("string1234567890", "string1", 999)
    >> 9

When given a pair of strings such that the distance between the two strings is greater than the "maximum distance" paramter, Vladlev will return the length of the longest string rather than spend the effort of calculating the distance when you know that you are not interested in the result.

## Development

Vladlev uses rake-compiler for a build tool

    bundle exec rake compile

    bundle exec rake clean

For an agressive clean of compiled files, you can do this

    bundle exec rake clobber
