module RoleHelper

  def is_checked_resource selected_resource_ids,resource_id
      if selected_resource_ids.include?(resource_id)
          return 'checked'
      end
     return ''
  end
end