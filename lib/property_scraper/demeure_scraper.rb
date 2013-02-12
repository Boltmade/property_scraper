module PropertyScraper
  class DemeureScraper < Scraper

    def self.can_scrape?(url)
      url =~ /.*demeure.*\/properties\/.*/
    end

    def name
      @name ||= self.find('.viewproperty-summary h1')
    end

    def location
      @location ||= self.find('.location')
    end

    def lat
      @lat ||= @wrapped_document.at('.map').attr('data-latitude').to_f
    end

    def lng
      @lng ||= @wrapped_document.at('.map').attr('data-longitude').to_f
    end

    def bedrooms
      @bedrooms ||= self.find('.rooms .icon-rooms')
    end

    def max_occupancy
      @max_occupancy ||= self.find('.rooms .icon-sleeps')
    end

    def bathrooms
      @bathrooms ||= self.find('.rooms .icon-washrooms')
    end

    def description
      @description ||= @wrapped_document.at('.description').inner_html.strip
    end

    def photos
      @wrapped_document.css('.photogallery img').map do |img|
        img.attr('src').sub('large_cover', 'original')
      end.compact.uniq
    end

    def price
      @from_price ||= self.find('#price_amount')
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
