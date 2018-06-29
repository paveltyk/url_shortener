require File.expand_path '../spec_helper.rb', __FILE__

describe "URL Shortener Sinatra Web Server" do
  describe "GET /:id" do
    it "responds with 301 redirect on success (use 302 if we want counters)" do
      long_url = 'http://www.long-url.org/?a=1'
      url = UrlShortener.shorten_url(long_url)
      get "/#{url.id}"

      expect(last_response).to be_redirect
      expect(last_response.status).to eq(301)
      expect(last_response.location).to eq(long_url)
    end

    it "responds 404 if id not found" do
      get "/invalid"

      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq('Not found')
    end
  end

  describe "POST /urlshortener/v1/url" do
    it "responds with success for valid payload" do
      post '/urlshortener/v1/url'

      expect(last_response).to be_ok
    end

    it "responds with valid data" do
      long_url = 'http://www.long-url.org/?a=1'
      post '/urlshortener/v1/url', longUrl: long_url
      res = JSON.parse(last_response.body)

      expect(res['longUrl']).to eq(long_url)
      expect(res['id']).to_not be_nil
    end
  end
end
