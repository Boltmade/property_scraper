require "property_scraper/version"
require "property_scraper/scraper"
require "property_scraper/homeaway_scraper"
require "property_scraper/airbnb_scraper"
require "property_scraper/luxury_retreats_scraper"

module PropertyScraper
  class InvalidUrl < StandardError; end

  Scrapers = [AirbnbScraper, LuxuryRetreatsScraper]

  def self.scrape(url)
    Scrapers.each do |scraper|
      return scraper.new(url) if scraper.can_scrape?(url)
    end

    raise InvalidUrl
  end

end
