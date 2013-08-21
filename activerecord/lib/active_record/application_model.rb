require 'active_record/base'

module ActiveRecord
  class ApplicationModel
    class << self
      attr_accessor :isolated

      def configs_from(mod)
        self.isolated = true

        mod.define_singleton_method(:application_model_namespace) { mod }

        application_model = self
        mod.define_singleton_method(:application_model) { application_model }
      end

      def method_missing(name, *args, &block)
        ActiveRecord::Base.send(name, *args, &block)
      end

      def get_config(name, context = self)
        if context.respond_to?(:application_model)
          context.application_model.send(name)
        else
          ActiveRecord::Base.send(name)
        end
      end

      def respond_to?(name)
        ActiveRecord::Base.respond_to?(name)
      end

      private

        def generate_application_model_name(mod)
          "#{mod}ApplicationModel"
        end
    end
  end
end
