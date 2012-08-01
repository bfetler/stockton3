class Stock < ActiveRecord::Base
  attr_accessible :companyname, :companysymbol, :delta, :value

  validates :companyname,	:presence => true
  validates :companysymbol,	:presence => true
end
