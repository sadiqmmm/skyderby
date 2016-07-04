# == Schema Information
#
# Table name: manufacturers
#
#  id   :integer          not null, primary key
#  name :string(510)
#  code :string(510)
#

FactoryGirl.define do
  factory :manufacturer do
    name 'Phoenix Fly'
    code 'PF'
  end
end
