# == Schema Information
#
# Table name: gifs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  keyword    :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Gif < ActiveRecord::Base
  belongs_to :user
end
