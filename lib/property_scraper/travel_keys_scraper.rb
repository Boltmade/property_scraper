module PropertyScraper
  class TravelKeysScraper < Scraper

    def self.can_scrape?(url)
      url =~ /.*travelkeys.*\/villa-listing\/.*/
    end

    def name
      @name ||= self.find('#propertyname')
    end

    def location
      @location ||= self.find('#detailaddress')
    end

    def lat
    end

    def lng
    end

    def bedrooms
      @bedrooms ||= self.find('#detailremainder').match(/(\d+) Bedrooms/).try(:[], 1).try(strip)
    end

    def max_occupancy
    end

    def bathrooms
      @bathrooms ||= self.find('#detailremainder').match(/(\d+) Baths/).try(:[], 1).try(:strip)
    end

    def description
      @description ||= self.find('#description p')
    end

    def photos
      @wrapped_document.css('.singleimage img').map do |img|
        img.attr('src')
      end.compact.uniq
    end

    def price
      @from_price ||= self.find('#startingrate .currency-value')
    end

    def fees
      @fees ||= self.find('#charges')
    end

    def policies
      @policies ||= policies_section['policies']
    end

    def location_details
      @location_details ||= policies_section['distances']
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

    def policies_section
      @policies_section ||= build_policies_section
    end

    def build_policies_section
      policies_section = {}
      @wrapped_document.css('#policies div').each do |node|
        header = node.at('h2').content.downcase
        policies_section[header] = node.css('ul li').map {|li| li.content }
      end
      policies_section
    end

  end
end
