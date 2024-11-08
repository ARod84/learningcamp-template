# app/controllers/preferences_controller.rb
class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_preference, only: %i[show update destroy]

  def show
    render json: @preference
  end

  def create
    @preference = Preference.new(preference_params)

    if @preference.save
      render json: { message: 'Preference created successfully' }, status: :created
    else
      render json: { errors: @preference.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @preference.update(preference_params)
      render json: @preference, status: :ok
    else
      render json: { errors: @preference.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @preference.destroy
    head :no_content
  end

  private

  def set_preference
    @preference = Preference.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Preference not found' }, status: :not_found
  end

  def preference_params
    params.require(:preference).permit(:name, :description, :restriction)
  end
end
