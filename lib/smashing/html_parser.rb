require 'nokogiri'

# Unfortunately, Nokogiri and any other HTML/XML parsers
# do not seem to support advanved CSS selectors like this a[href~="some-text"]
# to detect tags whose attribute contains some text
# But we can check the tag content instead
module Smashing
  module HtmlParser
    def image_urls_per_resolution(html, resolution)
      doc = Nokogiri::HTML(html)
      doc.search("a:contains('#{resolution}')").map { |link| link.attributes['href'].value }
    end
  end
end
