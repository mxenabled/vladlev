# Define the default action when you just run 'make'
all: compile test

# Compile the C extension using the existing Rake task
compile:
	bundle exec rake compile

# Run the test suite
test:
	bundle exec rake spec

# Clean compiled artifacts
clean:
	bundle exec rake clean

# Remove all generated files (more aggressive than clean)
clobber:
	bundle exec rake clobber

# Build the gem package
build:
	gem build vladlev.gemspec

.PHONY: all compile test clean clobber build
