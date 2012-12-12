module PropertyScraper
  class LoveHomeSwapScraper < Scraper

    def self.can_scrape?(url)
      url =~ /.*lovehomeswap.*\/home-exchange\/.*/
    end

    def name
      @name ||= self.find('h2.translatable')
    end

    def location
      @location ||= self.find('#detail .head h1').gsub(/\|.*/, '').strip
    end

    def lat
      @lat ||= @wrapped_document.xpath("//meta[@property='lovehomeswap:location:latitude']/@content").first.value.to_f
    end

    def lng
      @lng ||= @wrapped_document.xpath("//meta[@property='lovehomeswap:location:longitude']/@content").first.value.to_f
    end

    def bedrooms
      @bedrooms ||= self.find('p.sleeps').match(/Bedrooms (\d+)/)[1].strip.to_i
    end

    def max_occupancy
      @max_occupancy ||= self.find('p.sleeps').match(/Sleeps (\d+)/)[1].strip.to_i
    end

    def bathrooms
      @bathrooms ||= self.find('p.sleeps').match(/Bathrooms (\d+)/)[1].strip.to_i
    end

    def description
      @description ||= @wrapped_document.at('p.richtext.translatable').inner_html.strip
    end

    def photos
      @wrapped_document.css('#gallery img').map do |img|
        img.attr('src')
      end.compact.uniq
    end

    def price
      0.00
    end

  end
end
