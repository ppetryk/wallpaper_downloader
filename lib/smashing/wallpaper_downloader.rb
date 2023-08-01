require_relative 'page_finder'
require_relative 'html_parser'
require 'httparty'
require 'logger'

module Smashing
  class WallpaperDownloader
    include PageFinder
    include HtmlParser

    HTTP_TIMEOUT = 10

    def initialize(options)
      @month, @resolution = options[:month], options[:resolution]
      @logger = Logger.new $stdout
    end

    def perform
      @logger.info 'Started'

      page_url = month_page @month
      page_response = HTTParty.get(page_url, timeout: HTTP_TIMEOUT)

      if page_response.code == 200
        @logger.info "Page #{page_url} has been found"

        image_urls = image_urls_per_resolution page_response.body, @resolution
        @logger.info "#{image_urls.count} wallpaper(-s) have been found"

        image_urls.each do |image_url|
          fn = File.basename image_url
          image_response = HTTParty.get(image_url, timeout: HTTP_TIMEOUT)

          if image_response.code == 200
            File.write(fn, image_response.body)
            @logger.info "Wallpaper #{fn} has been downloaded"
          else
            @logger.error "Wallpaper #{fn} failed to be downloaded"
          end
        rescue StandardError => e
          @logger.fatal "Wallpaper #{fn} failed to be downloaded due to the error: #{e}"
        end

        @logger.info 'Finished'
      else
        @logger.error "Page #{page_url} failed to be found"
      end
    rescue StandardError
      @logger.fatal 'Wallpapers failed to be downloaded'
    end
  end
end
