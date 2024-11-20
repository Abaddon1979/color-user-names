# name: color-user-names
# about: Colors usernames based on group membership
# version: 0.1.0
# authors: Abaddon
# url: https://github.com/Abaddon1979/color-user-names

enabled_site_setting :color_user_names_enabled

after_initialize do
  load File.expand_path('../app/controllers/color_user_name_controller.rb', __FILE__)
  load File.expand_path('../app/lib/color_user_names.rb', __FILE__)

  Discourse::Application.routes.append do
    post '/color_user_names/group_order' => 'color_user_names#create_group_order'
  end
end