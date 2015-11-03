unless RUBY_PLATFORM =~ /java/
  require 'mkmf'

  create_makefile('levenshtein')
end
