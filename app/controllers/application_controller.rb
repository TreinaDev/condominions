class ApplicationController < ActionController::Base
  before_action :warn_tower_registration_incomplete

  private

  def warn_tower_registration_incomplete
    return unless manager_signed_in?
    return if controller_name == 'towers' && action_name == 'edit_floor_units'

    Tower.incomplete.each do |tower|
      flash.now[:warning] ||= ''
      flash.now[:warning] << generate_html_message(tower)
    end
  end

  def generate_html_message(tower)
    message = <<~HTML
      Cadastro do(a) <strong>#{tower.name}</strong> do(a) <strong>#{tower.condo.name}</strong> incompleto(a), por favor, atualize o pavimento tipo.
    HTML

    view_context.link_to(
      view_context.sanitize(message), edit_floor_units_condo_tower_path(tower.condo, tower),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end
end
