require 'data_mapper'


class User
  include DataMapper::Resource

  	property :id,					Serial
  	property :guid,					String
  	property :generations_count,	Integer

	has n, :generations
end