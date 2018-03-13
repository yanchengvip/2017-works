module ApplicationHelper
  def contact_to_str contact
    "#{contact&.country} #{contact&.province} #{contact&.city} #{contact&.town} #{contact&.address}
    #{contact&.name} #{contact&.phone}"
  end
end
