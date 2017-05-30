module ShopifyImport
  module Creators
    class Customer
      def initialize(shopify_data_feed)
        @shopify_data_feed = shopify_data_feed
      end

      def save!
        Spree.user_class.transaction do
          @spree_user = create_spree_user
          generate_api_key
          assign_spree_user_to_data_feed
        end
      end

      private

      def create_spree_user
        temp_password = SecureRandom.hex(64)
        existing_attributes = user_attributes.select { |a| Spree.user_class.attribute_method?(a) }
        user = Spree.user_class.new(
          existing_attributes.merge(password: temp_password, password_confirmation: temp_password)
        )
        user.try(:skip_confirmation!)
        user.save!
        user
      end

      def assign_spree_user_to_data_feed
        @shopify_data_feed.update!(spree_object: @spree_user)
      end

      def generate_api_key
        @spree_user.try(:generate_spree_api_key!)
      end

      def user_attributes
        parser.user_attributes
      end

      def parser
        @parser ||= ShopifyImport::DataParsers::Customers::BaseData.new(shopify_customer)
      end

      def shopify_customer
        @shopify_customer ||= ShopifyAPI::Customer.new(JSON.parse(@shopify_data_feed.data_feed))
      end
    end
  end
end
