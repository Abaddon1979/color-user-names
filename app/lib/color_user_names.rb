module ColorUserNames
  class << self
    def create_group_order(group_order)
      group_order.each_with_index do |group, index|
        GroupSetting.create(
          plugin_name: 'color_user_names',
          name: "group_#{index}",
          value: group.strip
        )
      end
    end

    def get_group_order
      group_settings = GroupSetting.where(plugin_name: 'color_user_names')
                                   .where('name LIKE ?', 'group_%')
                                   .order(:name)
                                   .pluck(:value)

      group_order = {}
      group_settings.each_with_index do |setting, index|
        group_order[setting] = index
      end

      group_order
    end
  end
end