module NakedModel
  
  module ActiveRecordInclusions
    def self.included(included_into)
      included_into.extend(ClassMethods)
      class << included_into; attr_accessor :naked_models_covered_up_columns; end
      class << included_into; attr_accessor :naked_models_exposed_columns; end
      class << included_into; attr_accessor :naked_models_readonly_columns; end
      
      included_into.class_eval do
        # Intercept to_xml and add options based on Naked Model configuration.
        alias_method_chain :to_xml, :naked_opts
      end
    end
    
    def to_xml_with_naked_opts(options = {})
      naked_opts = {}
      naked_opts[:include] = (self.class.naked_models_exposed_columns || []).collect {|c| c.name.to_sym }
      naked_opts[:except] = (self.class.naked_models_covered_up_columns || []).collect {|c| c.to_sym }
      logger.debug("to_xml_with_naked_opts = #{naked_opts.merge(options).inspect}")
      to_xml_without_naked_opts(naked_opts.merge(options))
    end

  end

  module ClassMethods
    def naked_model_read_write_columns
      self.naked_models_readonly_columns ||= [ :id, :created_at, :updated_at, :rgt, :lft ]
      readonly = self.naked_models_readonly_columns.collect {|c| c.to_s }
      self.naked_model_read_only_columns.reject {|c| readonly.include?(c.name) }
    end
    
    def naked_model_read_only_columns
      exposed = self.naked_models_exposed_columns || []
      covered = (self.naked_models_covered_up_columns || []).collect {|c| c.to_s }
      cols = self.columns + exposed
      cols.reject! {|c| covered.include?(c.name) }
      cols
    end
  end
  
  module ActiveRecordExtensions
    def cover_up(*methods)
      self.naked_models_covered_up_columns = methods
    end
  
    # Can be called multiple times to add additional exposed methods.
    # Type can be one of the following:
    #   :integer, :float, :decimal, :datetime, :date, :timestamp, :time, :text, :string, :binary, :boolean
    def expose(method_name, type)
      (self.naked_models_exposed_columns ||= []) << NakedModel::Column.new(method_name.to_s, type)
    end
  
    # Defaults to [ :id, :created_at, :updated_at, :rgt, :lft ]
    def readonly_columns(*methods)
      self.naked_models_readonly_columns = methods
    end
  end
  
end