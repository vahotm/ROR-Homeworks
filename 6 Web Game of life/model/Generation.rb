require 'data_mapper'


class Generation
  include DataMapper::Resource

  	property :id,		Serial
  	property :state,	Object
  	property :width,	Integer
  	property :height,	Integer

  	belongs_to :user
end
