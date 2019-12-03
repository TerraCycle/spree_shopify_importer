module SpreeShopifyImporter
  module Importers
    class TaxonImporterJob < ::SpreeShopifyImporterJob
      def perform(resource)
        config = Spree::Config[:shopify_current_credentials]

        if config
          ShopifyAPI::Base.api_version = config[:api_version]
          ShopifyAPI::Base.site = "https://#{config[:api_key]}:#{config[:password]}@#{config[:shop_domain]}/admin/"
        end
        SpreeShopifyImporter::Importers::TaxonImporter.new(resource).import!
      end
    end
  end
end
