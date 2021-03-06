module SpreeShopifyImporter
  class Invoker
    ROOT_FETCHERS = [
      SpreeShopifyImporter::DataFetchers::ProductsFetcher,
      SpreeShopifyImporter::DataFetchers::TaxonsFetcher
    ].freeze
# TO DO: fetching api_version and setting as shopify_api_version
    def initialize(credentials: nil, options: {})
      @options = options
      @credentials = credentials
      @credentials ||= {
        api_key: Spree::Config[:shopify_api_key],
        password: Spree::Config[:shopify_password],
        shop_domain: Spree::Config[:shopify_shop_domain],
        token: Spree::Config[:shopify_token],
        api_version: Spree::Config[:shopify_api_version],
      }
    end

    def import!
      connect

      initiate_import!
    end

    private

    def connect
      set_current_credentials
      SpreeShopifyImporter::Connections::Client.instance.get_connection(@credentials)
    end

    def set_current_credentials
      Spree::Config[:shopify_current_credentials] = @credentials
    end

    # TODO: custom params for fetchers
    def initiate_import!
      ROOT_FETCHERS.each do |fetchers|
        fetchers.new(@options).import!
      end
    end
  end
end
