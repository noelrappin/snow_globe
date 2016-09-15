class Affiliate < ApplicationRecord

  include HasReference

  belongs_to :user

  def self.generate_tag
    generate_reference(length: 5, attribute: :tag)
  end

end
