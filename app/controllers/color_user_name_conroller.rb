class ColorUserNamesController < ApplicationController
  def create_group_order
    group_order = params[:group_order].split(',')
    ColorUserNames.create_group_order(group_order)
    head :ok
  end
end