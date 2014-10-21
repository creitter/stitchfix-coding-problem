FactoryGirl.define do  
  
  factory :clearance_batch do

  end

  factory :item do
    style
    color "Blue"
    size "M"
    status "sellable"
  end


  factory :style do
    wholesale_price 55
  end


  factory :style_dress, class: Style do
    type "Dress"
  end


  factory :style_pants, class: Style do
    type "Pants"
    wholesale_price 6
  end

  
  factory :style_scarf, class: Style do
    type "Scarf"
    wholesale_price 3
  end
  
end
