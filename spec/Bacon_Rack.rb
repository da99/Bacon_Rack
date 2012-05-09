
describe ":redirects_to" do
  
  it "fails if status is one of: 301, 302, 303, 307" do
    %w{ 200 304 305 306 }.each { |s|
      should.raise Bacon::Error do
        last_response.status = Integer(s)
        last_response['Location'] = '/'
        
        redirects_to "/"
      end.message.should.==("[301, 302, 303, 307].include?(#{s}) failed")
    }
  end

  it "passes if status is in: 301, 302, 303, 307" do
    %w{ 301 302 303 307 }.each { |s|
      last_response.status = Integer(s)
      last_response['Location'] = '/pass'
      
      redirects_to '/pass'
    }
  end

  %w{ example.com www.example.com }.each { |str|
    it "ignores http://#{str} host in location header" do
      last_response.status = 301
      last_response['Location'] = "http://#{str}/new"
      
      redirects_to '/new'
    end
  }

  it "accepts both a status and path" do
    last_response.status = 303
    last_response['Location'] = "/news"

    redirects_to 303, "/news"
  end

end # === Bacon_Rack


describe ":renders" do
  
  it "fails if status is not 200" do
    response 304, "Body 1"
    
    should.raise(Bacon::Error) {
      renders "Body 1"
    }.message.should == '304.==(200) failed'
  end

  it "passes if status is 200" do
    response 200, "Body 2"

    renders "Body 2"
  end

  it "fails if Content-Length does not match bytesize of body" do
    response 200, "Body 3"
    last_response['Content-Length'] = 2

    should.raise(Bacon::Error) {
      renders "Body 3"
    }.message.should == "[nil, \"6\"].include?(2) failed"
  end

  it 'accepts a single string without a status' do
    response 200, "Single"
    renders "Single"
  end

end # === :renders

