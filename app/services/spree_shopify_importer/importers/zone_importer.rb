module SpreeShopifyImporter
  module Importers
    class ZoneImporter < BaseImporter
      def import!
        data_feed = process_data_feed

        if (spree_object = data_feed.spree_object).blank?
          creator.new(data_feed).create!
        else
          updater.new(data_feed, spree_object).update!
        end
      end

      private

      def creator
        SpreeShopifyImporter::DataSavers::Zones::ZoneCreator
      end

      def updater
        SpreeShopifyImporter::DataSavers::Zones::ZoneUpdater
      end

      def shopify_class
        ShopifyAPI::ShippingZone
      end
    end
  end
end
