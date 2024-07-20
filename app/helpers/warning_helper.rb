module WarningHelper
  def resident_residence_registration_pending_message(resident)
    view_context.link_to(
      view_context.sanitize(resident.warning_html_message_tenant), new_resident_tenant_path(resident),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end

  def resident_property_registration_pending_message(resident)
    view_context.link_to(
      view_context.sanitize(resident.warning_html_message_owner), new_resident_owner_path(resident),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end

  def tower_warning_flash_message(tower)
    view_context.link_to(
      view_context.sanitize(tower.warning_html_message), edit_floor_units_condo_tower_path(tower.condo, tower),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end
end
