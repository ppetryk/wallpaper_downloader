#!/usr/bin/env ruby

require_relative 'lib/smashing/wallpaper_downloader'
require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.on('-m', '--month MONTH', 'A month of the year') do |m|
    options[:month] = m
  end

  opts.on('-r', '--resolution RESOLUTION', 'A resolution of wallpapers') do |r|
    options[:resolution] = r
  end
end.parse!

Smashing::WallpaperDownloader.new(options).perform
