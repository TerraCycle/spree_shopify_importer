module SpreeShopifyImporter
  module Importers
    class ZoneImporterJob < ::SpreeShopifyImporterJob
      def perform(resource)
        SpreeShopifyImporter::Importers::ZoneImporter.new(resource).import!
      end
    end
  end
end
