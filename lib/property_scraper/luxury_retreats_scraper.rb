module PropertyScraper
  class LuxuryRetreatsScraper < Scraper

    def self.can_scrape?(url)
      url =~ /.*luxuryretreats.*\/villa-page\/.*/
    end

    def name
      @name ||= self.find('.fst_dtl h1')
    end

    def location
      @location ||= self.find('p.loc')
    end

    def bedrooms
      @bedrooms ||= self.find('ul.pd_top li:nth-child(1) span').to_i
    end

    def bathrooms
      @bathrooms ||= self.find('ul.pd_top li:nth-child(2) span').to_f
    end

    def description
      @description ||= @wrapped_document.at('#Description.tabs-container').inner_html.strip
    end

    def photos
      photos = []
      @wrapped_document.css('.rsImg').each do |img|
        photos << img.attr('href')
      end
      photos.compact.uniq
    end

    def price
      pricelable = @wrapped_document.at('.pricelable')
      @from_price ||= (pricelable.children - pricelable.elements).map(&:text).inject(&:+)
    end

    def data
      {
        :name           => self.name,
        :location       => self.location,
        :bedrooms       => self.bedrooms,
        :bathrooms      => self.bathrooms,
        :description    => self.description,
        :photos         => self.photos,
        :price          => self.price
      }
    end

  end
end
