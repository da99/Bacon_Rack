describe ":it_redirects_to" do
  
  it_redirects 301, "/301/body", "/body"
  it_redirects "/302/perma", "/perma" 
  
end # === :it_redirects_to


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

  it "ignores SERVER_NAME in location header" do
    last_request.env['SERVER_NAME'] = "random.org/"
    last_response.status = 301
    last_response['Location'] = "http://random.org/new"

    redirects_to '/new'
  end

  it "accepts both a status and path" do
    last_response.status = 303
    last_response['Location'] = "/news"

    redirects_to 303, "/news"
  end

end # === Bacon_Rack


describe ":renders" do

  it "passes if status is 200" do
    response 200, "Body 2"

    renders "Body 2"
  end

  it 'accepts a single string without a status' do
    response 200, "Single"
    renders "Single"
  end

  it 'accepts a regular expression in place of a String' do
    response 200, "Regular"
    renders %r!Regular!
  end
  
  it "fails if status is not 200" do
    response 304, "Body 1"
    
    should.raise(Bacon::Error) {
      renders "Body 1"
    }.message.should == '304.==(200) failed'
  end

  it "fails if Content-Length does not match bytesize of body" do
    response 200, "Body 3"
    last_response['Content-Length'] = 2

    should.raise(Bacon::Error) {
      renders "Body 3"
    }.message.should == "[nil, \"6\"].include?(2) failed"
  end

  it 'fails if regular expression does not match body' do
    response 200, "No match."
    should.raise( Bacon::Error ) {
      renders %r!No single.!
    }.message
    .should == "\"No match.\".=~(/No single./) failed"
  end

  it 'fails if String is not a full match with the body.' do
    response 200, "Partial string"
    should.raise( Bacon::Error ){
      renders 200, "string"
    }.message
    .should == "\"Partial string\".==(\"string\") failed"
  end

end # === :renders

describe ":renders_assets" do
  
  it "passes if relative links in pages all return a non-400, non-500 status" do
    response 200, %(
      <a href="/200/0.js">test</a>
      <a href="/301/1.css">test</a>
      <a href="/304/2.php">test</a>
    )

    renders_assets
  end
  
  it "fails if any relative link is within 400-510" do
    response 200, %(
      <a href="/200/0.js">test</a>
      <a href="/200/1.css">test</a>
      <a href="/509/2.gif">test</a>
    )

    should.raise(Bacon::Error) {
      renders_assets
    }.message.should == "200..310.include?(509) failed"
  end
  
end # === :renders_assets

