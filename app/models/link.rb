class Link < ActiveRecord::Base
	validates :shortlink, :link, presence: true
	validates :shortlink, :link, uniqueness: true
	validates :link, format: { with: URI::regexp(%w(http https)),
    message: "not valid, Url must with http:// || https://" }

    has_many :clicks
end
