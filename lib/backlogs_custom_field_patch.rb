require_dependency 'custom_field'

module BacklogsCustomFieldPatch
  def customized_class
    if self.respond_to?(:rb_sti_class)
      self.rb_sti_class.customized_class
    else
      super
    end
  end
end

class CustomField
  class << self
    prepend BacklogsCustomFieldPatch
  end
end