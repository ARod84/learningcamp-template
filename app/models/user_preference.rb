# == Schema Information
#
# Table name: user_preferences
#
#  id            :bigint           not null, primary key
#  user_id       :bigint           not null
#  preference_id :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_user_preferences_on_preference_id  (preference_id)
#  index_user_preferences_on_user_id        (user_id)
#
class UserPreference < ApplicationRecord
  belongs_to :user
  belongs_to :preference
end
