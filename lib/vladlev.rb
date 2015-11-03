module Vladlev
  def self.relative_exists?(filename)
    File.exists?(File.join(File.dirname(__FILE__), filename))
  end

  JRUBY_NATIVE = RUBY_PLATFORM =~ /java/ && relative_exists?('levenshtein.jar')
  C_EXT_NATIVE = !JRUBY_NATIVE && 
    (relative_exists?('levenshtein.bundle') || relative_exists?('levenshtein.so'))

  if JRUBY_NATIVE
    require 'java'
    require File.join(File.dirname(__FILE__), 'levenshtein.jar')

    # Calculate the levenshtein distance between two strings
    #
    # @param [String] first string to compare
    # @param [String] second string to compare
    # @return [Integer] the levenshtein distance between the strings
    def self._internal_distance(str1, str2, max)
      Java::LevenshteinDistance.distance(str1, str2, max)
    end
  elsif C_EXT_NATIVE
    require 'ffi'
    extend ::FFI::Library

    native_file_path = case
                       when relative_exists?('levenshtein.bundle') then
                         File.join(File.dirname(__FILE__), 'levenshtein.bundle')
                       else
                         File.join(File.dirname(__FILE__), 'levenshtein.so')
                       end

    ffi_lib native_file_path
    attach_function :levenshtein_extern, [:pointer, :pointer, :int32], :int32

    # Calculate the levenshtein distance between two strings
    #
    # @param [String] first string to compare
    # @param [String] second string to compare
    # @return [Integer] the levenshtein distance between the strings
    def self._internal_distance(str1, str2, max)
      self.levenshtein_extern(str1, str2, max)
    end
  else
    require 'vladlev/levenshtein'
    warn <<-PURE_RUBY
      Could not load C extension or Java Extension for Vladlev
      Will utilize pure ruby version which is significantly 
      slower for many comparisons.
    PURE_RUBY

    # Calculate the levenshtein distance between two strings
    #
    # @param [String] first string to compare
    # @param [String] second string to compare
    # @return [Integer] the levenshtein distance between the strings
    def self._internal_distance(str1, str2, max)
      ::Vladlev::Levenshtein.distance(str1, str2, max)
    end
  end

  def self.distance(str1, str2, max = 9999)
    return 0 if str1.nil? && str2.nil?
    return str2.size if str1.nil?
    return str1.size if str2.nil?

    self._internal_distance(str1, str2, max)
  end
end
