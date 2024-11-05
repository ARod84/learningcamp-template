# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  restriction :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Preference, type: :model do
  it 'creates a valid preference' do
    preference = Preference.new(name: 'Sample Name', description: 'Sample Description', restriction: true)
    expect(preference).to be_valid
  end

  it 'requires a name' do
    preference = Preference.new(description: 'Sample Description', restriction: true)
    expect(preference).not_to be_valid
  end
end
