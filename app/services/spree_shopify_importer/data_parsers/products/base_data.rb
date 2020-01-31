module SpreeShopifyImporter
  module DataParsers
    module Products
      class BaseData
        PROTOTYPES = {
            zero_waste_pallet: 'Zero Waste Pallet™',
            zero_waste_pouch: 'Zero Waste Pouch™',
            zero_waste_bag:'Zero Waste Bag™',
            zero_waste_supplies: 'Supplies',
            hazardous_box: 'Zero Waste Hazardous Box™',
            box: 'Zero Waste Box™',
            cigarette_receptacle: 'Cigarette Receptacle',
            recycling_container: 'Recycling Container'
        }.freeze

        def initialize(shopify_product)
          @shopify_product = shopify_product
        end

        def attributes
          @attributes ||= {
            name: @shopify_product.title,
            description: @shopify_product.body_html,
            available_on: @shopify_product.published_at,
            slug: @shopify_product.handle,
            price: @shopify_product.variants.first.try(:price) || 0,
            created_at: @shopify_product.created_at,
            shipping_category: shipping_category,
            stores: [store],
            prototype_id: prototype_id
          }
        end

        def tags
          @tags ||= @shopify_product.tags
        end

        def options
          @options ||= @shopify_product.options.reverse.uniq(&:values)
        end

        private

        def shipping_category
          if @shopify_product.shipping_category
            Spree::ShippingCategory.find_or_create_by!(name: @shopify_product.shipping_category)
          else
            Spree::ShippingCategory.find_or_create_by!(name: I18n.t(:shopify))
          end
        end

        def store
          Spree::Store.find_by(code: @shopify_product.store) || Spree::Store.default
        end

        def prototype_id
          PROTOTYPES.each do |search, name|
            return Spree::Prototype.find_by(name: name)&.id if @shopify_product.title.include?(search.to_s.titleize)
          end
          nil
        end

        def option_values(values)
          values.map(&:strip)
        end
      end
    end
  end
end
