class Affiliate < ApplicationRecord

  belongs_to :user

  def self.generate_tag
    loop do
      result = SecureRandom.hex(6)
      return result unless exists?(tag: result)
    end
  end

end
