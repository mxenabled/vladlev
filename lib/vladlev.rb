module Vladlev
  def self.file_fallback_path(*files)
    files.detect { |file| File.exists?(File.join(File.dirname(__FILE__), file)) }
  end

  JRUBY_NATIVE = RUBY_PLATFORM =~ /java/ && file_fallback_path('levenshtein.jar')
  C_EXT_NATIVE = !JRUBY_NATIVE && file_fallback_path('levenshtein.so', 'levenshtein.bundle')

  if JRUBY_NATIVE
    require 'java'
    require JRUBY_NATIVE

    # Calculate the levenshtein distance between two strings
    #
    # @param [String] first string to compare
    # @param [String] second string to compare
    # @return [Integer] the levenshtein distance between the strings
    def self._internal_distance(str1, str2, max)
      Java::LevenshteinDistance.distance(str1, str2, max)
    end

    def self._normalized_distance(str1, str2, max)
      Java::LevenshteinDistance.normalized_distance(str1, str2, max)
    end
  elsif C_EXT_NATIVE
    require 'ffi'
    extend ::FFI::Library

    ffi_lib C_EXT_NATIVE
    attach_function :levenshtein_extern, [:pointer, :pointer, :int32], :int32
    attach_function :normalized_levenshtein_extern, [:pointer, :pointer, :int32], :double

    # Calculate the levenshtein distance between two strings
    #
    # @param [String] first string to compare
    # @param [String] second string to compare
    # @return [Integer] the levenshtein distance between the strings
    def self._internal_distance(str1, str2, max)
      self.levenshtein_extern(str1, str2, max)
    end

    def self._normalized_distance(str1, str2, max)
      self.normalized_levenshtein_extern(str1, str2, max)
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

  def self.get_normalized_distance(str1, str2, max = 9999)
    return 0 if str1.nil? && str2.nil?
    return 1.0 if str1.nil?
    return 1.0 if str2.nil?

    self._normalized_distance(str1, str2, max)
  end
end
