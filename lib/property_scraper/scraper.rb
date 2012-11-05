require 'nokogiri'
require 'open-uri'

module PropertyScraper
  class Scraper

    attr_reader :url

    def initialize(url)
      @url = url
      self.scrape
    end

    def scrape
      @document = open(@url).read
      @wrapped_document = Nokogiri::HTML(@document)
    end

    def self.can_scrape?(url)
      false
    end

    def method_missing(method_sym)
    end

    def data
      {}
    end

    protected

    def find(selector)
      @wrapped_document.at(selector).content.strip
    end

  end
end
