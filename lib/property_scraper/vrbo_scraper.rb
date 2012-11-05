module PropertyScraper
  class VrboScraper < Scraper

    def self.can_scrape?(url)
      url =~ /.*vrbo.com\/.*/
    end

    def name
      @name ||= self.find('.reviews-container .rating-box .item .fn')
    end

    def location
      @location ||= @wrapped_document.at("//meta[@name='Location']/@content").value.gsub(">", ",").strip
    end

    def lat
      matches = @document.match('lat:([\d\.]*)')
      if matches.length > 1
        matches[1].to_f
      else
        0.to_f
      end
    end

    def lng
      matches = @document.match('lng:([\d\.]*)')
      if matches.length > 1
        matches[1].to_f
      else
        0.to_f
      end
    end

    def bedrooms
      matches = @document.match('([\d\.]+) Bedroom')
      if matches.length > 1
        matches[1].to_i
      else
        0
      end
    end

    def bathrooms
      matches = @document.match('([\d\.]+) Bathroom')
      if matches.length > 1
        matches[1].to_f
      else
        0
      end
    end

    def max_occupancy
      matches = @document.match('Sleeps ([\d\.]+)')
      if matches.length > 1
        matches[1].to_i
      else
        0
      end
    end

    def description
      @description ||= @wrapped_document.css('.column-left > p')[2].inner_html.strip
    end

    def photos
      photos = []
      @wrapped_document.css('.gallery-photo img').each do |img|
        photos << img.attr('src')
      end
      photos.compact
    end

    def price
    end

    def data
      {
        :name           => self.name,
        :location       => self.location,
        :lat            => self.lat,
        :lng            => self.lng,
        :bedrooms       => self.bedrooms,
        :bathrooms      => self.bathrooms,
        :max_occupancy  => self.max_occupancy,
        :description    => self.description,
        :photos         => self.photos,
        :price          => self.price
      }
    end

  end
end
