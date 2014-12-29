class DevicesController < ApplicationController
  def show
    @device = Device.find(params[:id])
  end

  def update
    @device = Device.find(params[:id])
    @device.update(device_params)

    render :text => 'ok'
  end

  private

  def device_params
    params.require(:device).permit(:display_name)
  end
end
