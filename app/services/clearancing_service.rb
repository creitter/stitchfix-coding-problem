require 'csv'
require 'ostruct'
class ClearancingService

  def process_file(uploaded_file)
    clearancing_status      = create_clearancing_status
    CSV.foreach(uploaded_file, headers: false) do |row|  
      potential_item_id = handle_integer_conversion(row[0])
      clearancing_status = process_item(potential_item_id, clearancing_status)
    end

    clearance_items!(clearancing_status) 
  end

  def process_list(list)
    clearancing_status = create_clearancing_status
    items = list.split(",")
    items.reject! { |c| c.empty? }
    items.each {|item|
      item = handle_integer_conversion(item)
      clearancing_status = process_item(item, clearancing_status)
    }
    clearance_items!(clearancing_status) 
  end
  
private

# I don't like returning a 0 if id isn't Numeric nor the mistake of an integer rounding error on a float.
  def handle_integer_conversion(id) 
    (Integer(id) rescue nil).nil? || id.to_i.to_s != id.to_s ? id : id.to_i
  end
  
  def process_item(item, clearancing_status) 
    clearancing_error = what_is_the_clearancing_error?(item)
    if clearancing_error
      clearancing_status.errors << clearancing_error
    else
      clearancing_status.item_ids_to_clearance << item
    end
    
    clearancing_status
  end

  def clearance_items!(clearancing_status)
    if clearancing_status.item_ids_to_clearance.any? 
      clearancing_status.clearance_batch.save!
      clearancing_status.item_ids_to_clearance.each do |item_id|
        item = Item.find(item_id)
        item.clearance!
        clearancing_status.clearance_batch.items << item
      end
    end
    clearancing_status
  end

  def what_is_the_clearancing_error?(potential_item_id)
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      return "Item id #{potential_item_id} is not valid"      
    end
    if Item.where(id: potential_item_id).none?
      return "Item id #{potential_item_id} could not be found"      
    end
    if Item.sellable.where(id: potential_item_id).none?
      return "Item id #{potential_item_id} could not be clearanced"
    end

    return nil
    
  end

  def create_clearancing_status
    OpenStruct.new(
      clearance_batch: ClearanceBatch.new,
      item_ids_to_clearance: [],
      errors: [])
  end

end
