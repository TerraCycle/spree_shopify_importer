module SpreeShopifyImporter
  module DataSavers
    module Zones
      class ZoneBase < BaseDataSaver
        delegate :attributes, to: :parser

        private

        def assign_spree_zone_to_data_feed
          @shopify_data_feed.update!(spree_object: @spree_zone)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::Zones::BaseData.new(shopify_shipping_zone)
        end

        def shopify_shipping_zone
          @shopify_shipping_zone ||= ShopifyAPI::ShippingZone.new(data_feed)
        end
      end
    end
  end
end
