class ApplicationController < ActionController::Base
  before_action :warn_tower_registration_incompleted

  private

  def warn_tower_registration_incompleted
    return unless manager_signed_in?
    return if controller_name == 'towers' && action_name == 'edit_floor_units'

    Tower.incompleted.each do |tower|
      flash.now[:warning] ||= ''
      flash.now[:warning] << generate_html_message(tower)
    end
  end

  def generate_html_message(tower)
    view_context.link_to(
      <<~HTML
        Cadastro do(a) <strong>#{tower.name}</strong> do(a) <strong>#{tower.condo.name}</strong> incompleto(a), por favor, atualize o pavimento tipo.
      HTML
      .html_safe, edit_floor_units_condo_tower_path(tower.condo, tower),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end
end
