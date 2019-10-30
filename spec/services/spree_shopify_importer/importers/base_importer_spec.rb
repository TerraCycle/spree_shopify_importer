require 'spec_helper'

RSpec.describe SpreeShopifyImporter::Importers::BaseImporter, type: :service do
  describe '#import!' do
    let(:data_feed) { double('DataFeed', spree_object: nil) }

    before do
      allow_any_instance_of(SpreeShopifyImporter::DataFeeds::Create).to receive(:save!).and_return(data_feed)
    end

    context 'shopify class' do
      let(:expected_message) { I18n.t('errors.not_implemented.shopify_class') }

      it 'raises not implemented error for shopify object' do
        expect { described_class.new.import! }.to raise_error(NotImplementedError).with_message(expected_message)
      end
    end

    context 'creator' do
      let(:expected_message) { I18n.t('errors.not_implemented.creator') }

      it 'raises not implemented error for creator' do
        allow_any_instance_of(described_class).
          to receive(:shopify_object).
          and_return(instance_spy('ShopifyObject'))

        expect { described_class.new.import! }.to raise_error(NotImplementedError).with_message(expected_message)
      end
    end

    context 'updater' do
      let(:expected_message) { I18n.t('errors.not_implemented.updater') }

      it 'raises not implemented error for updater' do
        allow_any_instance_of(described_class).to receive(:find_existing_data_feed).and_return(instance_double('DataFeed'))
        allow_any_instance_of(described_class).to receive(:shopify_object).and_return(instance_spy('ShopifyObject'))

        expect { described_class.new.import! }.to raise_error(NotImplementedError).with_message(expected_message)
      end
    end
  end
end
