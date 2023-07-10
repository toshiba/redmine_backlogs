require_dependency 'user'

module BacklogsUserPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
    end

    module InstanceMethods

      def backlogs_preference
        @backlogs_preference ||= BacklogsPreference.new(self)
      end

    end
end

User.send(:include, BacklogsUserPatch) unless User.included_modules.include? BacklogsUserPatch
