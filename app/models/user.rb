# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  login           :string
#  github_id       :integer
#  avatar          :string
#  profile_url     :string
#  email           :string
#  installation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_many :gifs
end
