class ApiController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def update_schemas
    app = App.find_by(:name => params[:app_name])
    schemas_data = JSON.parse(params[:schemas_data], :symbolize_names => true)
    schemas_data.each do |datum|
      schema = app.schemas.find_or_create_by(:name => datum[:name])
      schema.update(:schema => datum[:schema].to_json)
    end

    render :text => 'ok'
  end

  def update_storages
    app = App.find_by(:name => params[:app_name])
    device = Device.find_or_create_by(:app_id => app.id, :uuid => params[:device_uuid])
    storages_data = JSON.parse(params[:storages_data], :symbolize_names => true)
    storages_data.each do |datum|
      schema = Schema.find_by(:name => datum[:name])
      storage = device.storages.find_or_create_by(:schema_id => schema.id)
      if(datum[:saved_at] > storage.changed_at)
        storage.update(:data => datum[:data].to_json)
      end
    end

    render :text => 'ok'
  end

  def get_storages
    app = App.find_by(:name => params[:app_name])
    device = Device.find_or_create_by(:app_id => app.id, :uuid => params[:device_uuid])
    storages_data = device.storages.map do |s|
      data = s.attributes
      data[:name] = s.schema.name
      data
    end

    render :json => storages_data
  end
end
