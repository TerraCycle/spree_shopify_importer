module SpreeShopifyImporter
  module DataSavers
    module Zones
      class ZoneCreator < ZoneBase
        def create!
          Spree::Zone.transaction do
            @spree_zone = create_spree_zone
            assign_spree_zone_to_data_feed
            create_spree_zone_members
            # create tax_rates
            # create shipping_categories
          end
        end

        private

        def create_spree_zone
          zone = Spree::Zone.new(merged_attributes)
          zone.save!
          zone
        end

        def merged_attributes
          # tutaj sobie też posprawdzaj co jest
          # binding.pry
          attributes
            .select { |a| Spree::Zone.attribute_method?(a) }
        end
      end
    end
  end
end
