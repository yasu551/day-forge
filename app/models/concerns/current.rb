module Current
  extend ActiveSupport::Concern

  included do
    attribute :person_class
    attribute session_attribute_name
    delegate person_attribute_name, to: session_attribute_name, allow_nil: true
  end

  class_methods do
    def current_for(person_class)
      self.person_class = person_class
    end
  end

  def person_attribute_name
    person_class.name.underscore.to_sym
  end

  def session_attribute_name
    "#{person_attribute_name}_session".to_sym
  end
end
