module Api
  module V1
    class ComposeController < Api::V1::BaseController
      respond_to :json
      skip_before_filter :verify_authenticity_token
      def index
        @status = 'success'
        @message = 'OK'
        @greeting = "Hello"

      end

      def getTextSentiment
        # curl -X POST \
        # -d "outputMode=json" \
        # -d "url=http://techcrunch.com/2016/01/29/ibm-watson-weather-company-sale/" \
        # "https://gateway-a.watsonplatform.net/calls/url/URLGetText?apikey=$API_KEY"
        @text = params["text"]
        alc_key = ENV['ALCHEMY_API_KEY']
        @text_response = HTTParty.post("https://gateway-a.watsonplatform.net/calls/text/TextGetTextSentiment?apikey=#{alc_key}",
          :headers => {
            "url" => "positron.illcreative.com"
            },
          :query => {
            "outputMode" => "json",
            "extract" => "entities,keywords",
            "sentiment" => "1",
            "text" => @text
          })

        @keyword_response = HTTParty.post("https://gateway-a.watsonplatform.net/calls/text/TextGetRankedKeywords?apikey=#{alc_key}",
          :query => {
            "outputMode" => "json",
            "extract" => "entities,keywords",
            "sentiment" => "1",
            "text" => @text
          })

        if @text
          @status = 'success'
          @message = 'OK'
          @data = { 'text' => @text, 'text_response' => @text_response, 'keywords_response' => @keyword_response }
        else
          @status = 'error'
          @message = 'something went wrong'
        end
      end

      def getURLSentiment
        # curl -X POST \
        # -d "outputMode=json" \
        # -d "extract=entities,keywords" \
        # -d "sentiment=1" \
        # -d "maxRetrieve=1" \
        # -d "url=https://www.ibm.com/us-en/" \
        # "https://gateway-a.watsonplatform.net/calls/url/URLGetCombinedData?apikey=$API_KEY"
        @url = params["url"]
        alc_key = ENV['ALCHEMY_API_KEY']
        @url_response = HTTParty.post("https://gateway-a.watsonplatform.net/calls/url/URLGetCombinedData?apikey=#{alc_key}&url=#{@url}",
          :query => {
            "outputMode" => "json",
            "extract" => "entities,keywords",
            "sentiment" => "1",
            "maxRetrieve" => "1"
            })

        if @url
          @status = 'success'
          @message = 'OK'
          @data = {'url' => @url, 'url_response' => @url_response }
        else
          @status = 'error'
          @message = 'something went wrong'
        end
      end


    end
  end
end
