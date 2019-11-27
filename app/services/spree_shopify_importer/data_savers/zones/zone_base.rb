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

        def create_spree_zone_members
          if attributes[:kind] == 'country'
            find_countries_members
          else
            find_states_members
          end
        end

        def find_countries_members
          @spree_zone.countries << Spree::Country.where(iso: @shopify_shipping_zone.countries.map do |country|
            country.code
          end)
        end

        def find_states_members
          @shopify_shipping_zone.countries.each do |country|
            country_id = Spree::Country.find_by(iso: country.code).id
            if country.provinces.count != 0
              country.provinces.map do |province|
                @spree_zone.states << Spree::State.find_or_create_by(name: province.name, abbr: province.code, country_id: country_id)
              end
            else
              @spree_zone.states << Spree::State.where(country_id: country_id)
            end
          end

        end
      end
    end
  end
end
