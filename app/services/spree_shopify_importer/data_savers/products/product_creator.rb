module SpreeShopifyImporter
  module DataSavers
    module Products
      class ProductCreator < ProductBase
        def create!
          Spree::Product.transaction do
            @spree_product = create_spree_product
            assign_spree_product_to_data_feed
            add_option_types
            add_tags
          end
          create_spree_variants
          create_spree_images
        end

        private

        def create_spree_product
          product = Spree::Product.create!(attributes)
          product.stores << store
          product
        end
      end
    end
  end
end
