module NakedModel::ActiveRecordExtensions

  def self.included(included_into)
    included_into.extend(ClassMethods)
  end

  def cover_up(*methods)
    @@naked_models_covered_up_columns = methods
  end
  
  # Can be called multiple times to add additional exposed methods.
  # Type can be one of the following:
  #   :integer, :float, :decimal, :datetime, :date, :timestamp, :time, :text, :string, :binary, :boolean
  def expose(method_name, type)
    (@@naked_models_exposed_columns ||= []) << NakedModel::Column.new(method_name, type)
  end
  
  # Defaults to [ :id, :created_at, :updated_at, :rgt, :lft ]
  def readonly_columns(*methods)
    @@naked_models_readonly_columns = methods
  def

  module ClassMethods
    def naked_model_read_write_columns
      readonly = (@@naked_models_readonly_columns || [ :id, :created_at, :updated_at, :rgt, :lft ]).collect {|c| c.to_s }
      self.naked_model_read_only_columns.reject {|c| readonly.include?(c.name) }
    end
    
    def naked_model_read_only_columns
      exposed = @@naked_models_exposed_columns || []
      covered = (@@naked_models_covered_up_columns || []).collect {|c| c.to_s }
      cols = self.columns + exposed
      cols.reject! {|c| covered.include?(c.name) }
      cols
    end
  end
  
end