require_dependency 'user'

module BacklogsTrackerPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
    end

    module InstanceMethods
      def backlog?
        return (issue_statuses.collect{|s| s.backlog(self)}.compact.uniq.size == 4)
      end

      def status_for_done_ratio(r)
        return (issue_statuses.select{|s| !s.default_done_ratio.nil? && s.default_done_ratio < r && !s.is_closed?}.sort{|a, b| b.default_done_ratio <=> a.default_done_ratio} + [nil])[0]
      end
    end
end

Tracker.send(:include, BacklogsTrackerPatch) unless Tracker.included_modules.include? BacklogsTrackerPatch
