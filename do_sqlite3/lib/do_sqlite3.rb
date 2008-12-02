# HACK: If running on Windows, then add the current directory to the PATH
# for the current process so it can find the bundled dlls before the require
# of the actual extension file.
if RUBY_PLATFORM.match(/mingw|mswin/i)
  libdir = File.expand_path(File.dirname(__FILE__)).gsub(File::SEPARATOR, File::ALT_SEPARATOR)
  ENV['PATH'] = "#{libdir};" + ENV['PATH']
end

require 'rubygems'
require 'data_objects'
require 'do_sqlite3_ext'
require 'do_sqlite3/transaction'

if RUBY_PLATFORM =~ /java/
  require 'do_jdbc/sqlite3'   # the JDBC driver, packaged as a gem

  # Another way of loading the JDBC Class. This seems to be more relaible
  # than Class.forName() within the data_objects.Connection Java class,
  # which is currently not working as expected.
  require 'java'
  import 'org.sqlite.JDBC'

  module DataObjects
    module Sqlite3
      class Connection
        def self.pool_size
          20
        end
      end
    end
  end

end
