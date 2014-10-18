require 'rails_helper'

describe Item do
  describe "#perform_clearance!" do

    before do
      item.clearance!
      item.reload
    end

    context "at a clearance price greater than or equal to the minimum" do
      let(:wholesale_price) { 100 }
      let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price)) }

      it "should mark the item status as clearanced" do
        expect(item.status).to eq("clearanced")
      end

      it "should set the price_sold as 75% of the wholesale_price" do
        expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
      end
    end
    
    context "at price less than the minimum " do
      context "for a dress" do
        let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style_dress, wholesale_price: 6)) }

        # TODO: Look up better way to re-use this specific test
        it "should mark the item status as clearanced" do
          expect(item.status).to eq("clearanced")
        end
        
        it "should set the price_sold at the minimum for a dress" do
          expect(item.price_sold).to eq(Item::MINIMUM_CLEARANCE_PRICE_FOR_SPECIAL)
        end
      end      

      context "for pants" do
        let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style_pants, wholesale_price: 6)) }

        it "should mark the item status as clearanced" do
          expect(item.status).to eq("clearanced")
        end
        
        it "should set the price_sold at the minimum for pants" do
          expect(item.price_sold).to eq(Item::MINIMUM_CLEARANCE_PRICE_FOR_SPECIAL)
        end
      end      

      context "for everything else" do
        let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style_scarf, wholesale_price: 1)) }

        it "should mark the item status as clearanced" do
          expect(item.status).to eq("clearanced")
        end
        
        it "should set the price_sold at the minimum for pants" do
          expect(item.price_sold).to eq(Item::MINIMUM_CLEARANCE_PRICE)
        end
      end      
    end
  end
end
