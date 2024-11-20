# frozen_string_literal: true

# name: color-user-names
# about: Colors user names based on group membership.
# version: 0.1
# authors: Your Name

enabled_site_setting :color_user_names_enabled

register_asset "stylesheets/color-user-names.scss"

after_initialize do
  module ::ColorUserNames
    PLUGIN_NAME ||= "color-user-names".freeze

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace ColorUserNames
    end
  end

  SiteSetting.set(:color_user_names_enabled, true)

  # CORRECT way to register dynamic settings (using register_dynamic_setting):
  Group.all.each do |group|
    register_dynamic_setting("color_user_names_group_#{group.id}_color")
  end

  add_to_serializer(:current_user, :group_colors) do
    ColorUserNames.generate_group_color_css
    Group.order(:position).map do |group|
      {
        group_id: group.id,
        color: SiteSetting.send("color_user_names_group_#{group.id}_color")
      }
    end
  end

  require_dependency 'color_user_names/username_decorator'
  Discourse::Cooked::UsernameDecorator.prepend(ColorUserNames::UsernameDecorator)

  add_admin_route 'color_user_names.index', 'color-user-names'

  Discourse::Application.routes.append do
    scope "/admin/plugins/color-user-names" do
      get "/groups" => "color_user_names#groups"
      put "/update_color/:id" => "color_user_names#update_color"
      put "/update_order" => "color_user_names#update_order"
    end
  end

  require_dependency 'application_controller'
  module ::ColorUserNames
    class ColorUserNamesController < ::ApplicationController
      requires_admin

      def groups
        groups = Group.order(:position).map do |group|
          { id: group.id, name: group.name, color: SiteSetting.send("color_user_names_group_#{group.id}_color") }
        end
        render json: { groups: groups }
      end

      def update_color
        group_id = params[:id].to_i
        color = params[:color]

        SiteSetting.set("color_user_names_group_#{group.id}_color", color)

        ColorUserNames.generate_group_color_css
        render json: { success: true }
      end

      def update_order
        group_order = params[:order].map(&:to_i)
        groups = Group.where(id: group_order)
        groups.each_with_index do |group, index|
          group.update_attribute(:position, index + 1)
        end
        ColorUserNames.generate_group_color_css
        render json: { success: true }
      end
    end
  end

end

def self.generate_group_color_css
  css = ""
  Group.order(:position).each do |group|
    color = SiteSetting.send("color_user_names_group_#{group.id}_color", "#000000")
    css << ".group-#{group.id}-colored-name { color: #{color}; }\n" # or span.group... if needed.
  end
  File.write("#{Rails.root}/plugins/color-user-names/assets/stylesheets/color-user-names.scss", css)
end