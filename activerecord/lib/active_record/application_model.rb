module ActiveRecord
  class ApplicationModel < ActiveRecord::Base
    class << self
      attr_accessor :isolated

      def configs_from(mod)
        self.isolated = true
        application_model_name = generate_application_model_name(mod)

        singleton_class.instance_eval do
          define_method(:application_model_namespace) { application_model_name }
        end
      end

      private

        def generate_application_model_name(mod)
          ActiveSupport::Inflector.underscore(mod).tr("/", "_")
        end
    end
  end
end
