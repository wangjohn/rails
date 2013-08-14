module ActiveRecord
  class ApplicationModel
    class << self
      attr_accessor :isolated

      def configs_from(namespace)
        self.isolated = true
        application_model_name = generate_application_model_name(namespace)

        singleton_class.instance_eval do
          define_method(:application_model_namespace) { application_model_name }
        end
      end

      private

        def generate_application_model_name(namespace)
          ActiveSupport::Inflector.underscore(namespace).tr("/", "_")
        end
    end
  end
end
