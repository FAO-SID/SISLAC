class SelectionsController < ApplicationController
  def update
    if current_user.present?
      if selection_params[:profile_id].present?
        current_user.current_selection << selection_params[:profile_id].to_i
      elsif selection_params[:remove].present?
        current_user.current_selection.delete selection_params[:remove].to_i
      end

      current_user.save
    end

    @selected = current_user.reload.try(:current_selection).try(:size)

    respond_to do |format|
      format.js
    end
  end

  def select_all
    if current_user.present?
      current_user.current_selection = selection_params[:profile_ids].select(&:present?)
      current_user.save
    end

    flash[:notice] = "#{current_user.current_selection.size} Perfiles seleccionados" if current_user.present?

    redirect_to :back
  end

  protected

  def selection_params
    params.require(:selections).permit(
      :profile_id, :remove,
      profile_ids: []
    )
  end
end
