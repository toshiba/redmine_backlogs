module Backlogs
  module ActiveRecord
    def add_condition(options, condition, conjunction = 'AND')
      #puts("add_condition op=#{options} cond=#{condition} conj=#{conjunction}")
      #4/0
      if condition.is_a? String
        add_condition(options, [condition], conjunction)
      elsif condition.is_a? Hash
        add_condition!(options, [condition.keys.map { |attr| "#{attr}=?" }.join(' AND ')] + condition.values, conjunction)
      elsif condition.is_a? Array
        options[:conditions] ||= []
        options[:conditions][0] += " #{conjunction} (#{condition.shift})" unless options[:conditions].empty?
        options[:conditions] = options[:conditions] + condition
      else
        raise "don't know how to handle this condition type"
      end
    end
    module_function :add_condition
  end
end