module SpreeShopifyImporter
  module DataSavers
    module Zones
      class ZoneUpdater < ZoneBase
        def initialize(shopify_data_feed, spree_zone)
          super(shopify_data_feed)
          @spree_zone = spree_zone
        end

        def update!
          Spree::Zone.transaction do
            update_spree_zone
          end
          create_spree_zone_members
          # create tax_rates
          # create shipping_categories
        end

        private

        def update_spree_zone
          @spree_zone.update!(merged_attributes)
        end

        def merged_attributes
          # binding.pry
          # attributes => {:name=>"Domestic", :description=>"shopify shipping to Poland", :kind=>"country"}
          attributes.select { |a| Spree::Zone.attribute_method?(a) }
        end
      end
    end
  end
end
