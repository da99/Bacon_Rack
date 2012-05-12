
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.print e.message, "\n"
  $stderr.print "Run `bundle install` to install missing gems\n"
  exit e.status_code
end
require 'bacon'

Gem_Dir = File.expand_path( File.join(File.dirname(__FILE__) + '/../..') )
$LOAD_PATH.unshift Gem_Dir
$LOAD_PATH.unshift( Gem_Dir + "/lib" )

Bacon.summary_on_exit

require 'Bacon_Rack'
require 'Bacon_Colored'
require 'pry'



# ======== Custom code.

class Bacon::Context
  
  def last_response
    @fake_rack ||= Fake_Rack.new
  end

  def response stat, body
    l = last_response
    l.status = stat
    l.body = body
    l['Content-Length'] = body.bytesize.to_s
  end

  def get str
    pieces = str.split('/').map(&:strip).reject(&:empty?)
    stat, body = pieces
    case stat.to_i
    when 300..310
      last_response['Location'] = File.join('/', *body)
    end

    last_response.status = Integer(stat)
  end

end # === class

class Fake_Rack < Hash
  
  attr_accessor :status, :body
  
  def last_response
    self
  end

  def ok?
    status == 200
  end

end # === Fake_Rack



# ======== Include the tests.
target_files = ARGV[1, ARGV.size - 1].select { |a| File.file?(a) }

if target_files.empty?
  
  # include all files
  Dir.glob('./spec/*.rb').each { |file|
    require file.sub('.rb', '') if File.file?(file)
  }
  
else 
  # Do nothing. Bacon grabs the file.
  
end
