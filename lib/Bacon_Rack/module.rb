module Bacon_Rack

  def redirects_to status, path = nil
    if status.is_a?(Integer)
      # do nothing
    else
      path, status = status, path
    end

    status ||= [ 301, 302, 303, 307 ]
    status = [ status ].compact.flatten

    status.should.include last_response.status

    last_response['Location'].sub(%r!http://(www.)?example\.com!, '')
    .should == path
  end
  
  def renders status, body = nil
    case status
    when Regexp, String
      body, status = status, body
    else
      # do nothing
    end
    
    status ||= 200
    l = last_response
    l.status.should == status
    
    case body
    when Regexp
      l.body.should.match body
    else
      l.body.should == body
    end

    [ nil, l.body.bytesize.to_s ]
    .should.include l['Content-Length']
  end

  def renders_assets
    files = last_response.body \
      .scan( %r!"(/[^"]+.(js|css|png|gif|ico|jpg|jpeg)[^"]*)"!i ) \
      .map(&:first)

    files.each { |f|
      get f
      last_response.should.be.ok
    }
  end

end # === class Bacon_Rack


__END__


  
  def renders str_or_regexp = nil
    r = case str_or_regexp
        when String
          %r!#{str_or_regexp}!
        else
          str_or_regexp
        end

    last_response.should.be.ok
    last_response.body.should.match( r ) if r
    [ nil, last_response.body.bytesize.to_s ]
    .should.include last_response['Content-Length']
  end
  
  # 301 - Permanent
  # 302 - Temporay
  def redirects_to path, code = 301 # permanent
    last_response.status.should == code
    last_response['Location'].sub(%r!http://(www.)?example.(org|com)!, '').should == path
  end

  def renders_assets
    files = last_response.body \
      .scan( %r!"(/[^"]+.(js|css|png|gif|ico|jpg|jpeg)[^"]*)"!i ) \
      .map(&:first)

    files.each { |f|
      get f
      last_response.should.be.ok
    }
  end
