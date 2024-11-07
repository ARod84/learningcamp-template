# spec/models/user_preference_spec.rb

require 'rails_helper'

RSpec.describe UserPreference, type: :model do
  # Association tests
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:preference) }
end
