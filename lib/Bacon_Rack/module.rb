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
      (200..310).should.include last_response.status
    }
  end

end # === class Bacon_Rack

