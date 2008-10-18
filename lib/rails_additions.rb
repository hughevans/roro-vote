module ActiveRecord
  class Base
    class << self
      # Will ensure the set of provided attributes is unique - ie: no other
      # record should have the same combination of values for the same
      # attributes.
      #
      # Example:
      #   validates_uniqueness_of_set :first_name, :last_name
      def validates_uniqueness_of_set(*attr_names)
        configuration = {
          :message => ActiveRecord::Errors.default_error_messages[:taken],
          :case_sensitive => true
        }
        configuration.update(attr_names.extract_options!)
        
        validate do |record|
          condition_sql    = []
          condition_params = []
          
          attr_names.each do |attr_name|
            value = record.send(attr_name)
                      
            if value.nil? || (configuration[:case_sensitive] || !columns_hash[attr_name.to_s].text?)
              condition_sql << "#{record.class.table_name}.#{attr_name} #{attribute_condition(value)}"
              condition_params << value
            else
              condition_sql << "LOWER(#{record.class.table_name}.#{attr_name}) #{attribute_condition(value)}"
              condition_params << value.downcase
            end
          end
          
          if scope = configuration[:scope]
            Array(scope).map do |scope_item|
              scope_value = record.send(scope_item)
              condition_sql << " #{record.class.table_name}.#{scope_item} #{attribute_condition(scope_value)}"
              condition_params << scope_value
            end
          end
          
          unless record.new_record?
            condition_sql << " #{record.class.table_name}.#{record.class.primary_key} <> ?"
            condition_params << record.send(:id)
          end

          # The check for an existing value should be run from a class that
          # isn't abstract. This means working down from the current class
          # (self), to the first non-abstract class. Since classes don't know
          # their subclasses, we have to build the hierarchy between self and
          # the record's class.
          class_hierarchy = [record.class]
          while class_hierarchy.first != self
            class_hierarchy.insert(0, class_hierarchy.first.superclass)
          end

          # Now we can work our way down the tree to the first non-abstract
          # class (which has a database table to query from).
          finder_class = class_hierarchy.detect { |klass| !klass.abstract_class? }

          if finder_class.find(:first, :conditions => [condition_sql.join(" AND "), *condition_params])
            record.errors.add(attr_names.first, configuration[:message])
          end
        end
      end
    end
  end
end
