class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")
  MINIMUM_CLEARANCE_PRICE_FOR_SPECIAL = 5
  MINIMUM_CLEARANCE_PRICE = 2

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }

  def clearance!
    new_price = style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
    
    if ['Pants','Dress'].include?(self.style.type) && new_price < MINIMUM_CLEARANCE_PRICE_FOR_SPECIAL
      new_price = MINIMUM_CLEARANCE_PRICE_FOR_SPECIAL
    elsif new_price < MINIMUM_CLEARANCE_PRICE
      new_price = MINIMUM_CLEARANCE_PRICE
    end
    
    update_attributes!(status: 'clearanced', 
                       price_sold: new_price)
  end

end
