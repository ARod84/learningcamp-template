# frozen_string_literal: true

class PreferencesController < ApplicationController
  before_action :authenticate_user!, :set_preference, only: %i[show update]

  def show
    @preference = Preference.find(params[:id])
    render json: @preference
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Preference not found' }, status: :not_found
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
      render json: @preference
    else
      render json: { errors: @preference.errors.full_messages }, status: :unprocessable_entity
    end
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
