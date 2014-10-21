class ClearanceBatchesController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all
  end

  def create
    clearancing_status = ClearancingService.new.process_file(params[:csv_batch_file].tempfile)
    clearance_batch    = clearancing_status.clearance_batch
    alert_messages     = []
    if clearance_batch.persisted?
      flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
    else
      alert_messages << "No new clearance batch was added"
    end
    if clearancing_status.errors.any?
      alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
      clearancing_status.errors.each {|error| alert_messages << error }
    end
    flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    redirect_to action: :index
  end
  
  
  def show_all_items
    batch_id = params[:batch_id]
    
    if batch_id.present? && batch_id.to_i == Integer(batch_id)
      batch = ClearanceBatch.where(id: batch_id).first
      if !batch.nil?
        items = []
        batch.items.each {|item|

          items << {item: item, style: item.style}
        }
      end
    end
    
    items ||= []
    
    render json: {items: items}, status: :ok
  end
  

end
