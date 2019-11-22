module SpreeShopifyImporter
  module DataParsers
    module Zones
      class BaseData
        def initialize(shopify_shipping_zone)
          @shopify_shipping_zone = shopify_shipping_zone
        end

        def attributes
          @attributes ||= {
            name: @shopify_shipping_zone.name,
            description: description
          }
        end

        private

        def description
          countries = @shopify_shipping_zone.countries.map do |country|
            country.attributes['name']
          end
          "shopify shipping to " + countries.join(',')
        end
      end
    end
  end
end
