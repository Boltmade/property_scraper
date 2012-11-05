module PropertyScraper
  class HomeawayScraper < Scraper

    def self.can_scrape?(url)
      url =~ /.*homeaway.*\/vacation-rental\/p.*/
    end

    def name
      @name ||= self.find('.topHeader h1')
    end

    def location
    end

    def lat
      @lat ||= @wrapped_document.at("#map").attr('data-lat').to_f
    end

    def lng
      @lng ||= @wrapped_document.at("#map").attr('data-lng').to_f
    end

    def bedrooms
    end

    def max_occupancy
    end

    def bathrooms
    end

    def description
      @description ||= @wrapped_document.at('.prop-desc-txt').inner_html.strip
    end

    def photos
      @wrapped_document.css('#photos_div img').map do |img|
        img.attr('src').sub('mini_square.jpg', 'x_large.jpg')
      end.compact.uniq
    end

    def price
      @from_price ||= self.find('#price_amount')
    end

    def data
      {
        :name           => self.name,
        :location       => self.location,
        :lat            => self.lat,
        :lng            => self.lng,
        :bedrooms       => self.bedrooms,
        :max_occupancy  => self.max_occupancy,
        :bathrooms      => self.bathrooms,
        :description    => self.description,
        :photos         => self.photos,
        :price          => self.price
      }
    end

    protected

    def details
      @wrapped_document.search('#description_details li').each_with_object({}) do |detail, details|
        case detail.at('.property').text
        when /Accommodates:/
          details[:max_occupancy] = detail.at('.value').text.to_i
        when /Bedrooms:/
          details[:bedrooms] = detail.at('.value').text.to_i
        when /Bathrooms:/
          details[:bathrooms] = detail.at('.value').text.to_i
        end
      end
    end

  end
end
