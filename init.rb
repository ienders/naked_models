require File.join(File.dirname(__FILE__), 'lib', 'naked_model')
require File.join(File.dirname(__FILE__), 'lib', 'naked_model', 'active_record')

::ActiveRecord::Base.send :include, NakedModel::ActiveRecord
