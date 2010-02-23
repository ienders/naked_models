module NakedModel
  
  class Column < ActiveRecord::ConnectionAdapters::Column
      
    # type can be one of: 
    # :integer
    # :float
    # :decimal
    # :datetime
    # :date
    # :timestamp
    # :time
    # :text, :string
    # :binary
    # :boolean
    def initialize(name, type)
      @name = name
      @type = type
    end
    
  end
  
  
end