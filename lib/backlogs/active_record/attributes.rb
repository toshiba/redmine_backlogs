module Backlogs
  module ActiveRecord
    module Attributes
      def self.included receiver
        receiver.extend ClassMethods
      end

      module ClassMethods
        def rb_sti_class
          return self.ancestors.select{|klass| klass.name !~ /^Rb/ && klass.ancestors.include?(::ActiveRecord::Base)}[0]
        end
      end

      def available_custom_fields
        klass = self.class.respond_to?(:rb_sti_class) ? self.class.rb_sti_class : self.class
        CustomField.where("type = '#{klass.name}CustomField'").order('position')
      end

      def journalized_update_attributes!(attribs)
        self.init_journal(User.current)
        attribs = attribs.to_enum.to_h
        return self.update!(attribs)
      end
      def journalized_update_attributes(attribs)
        self.init_journal(User.current)
        attribs = attribs.to_enum.to_h
        return self.update(attribs)
      end
      def journalized_update_attribute(attrib, v)
        self.init_journal(User.current)
        return self.update(attrib, v)
      end
    end
  end
end
