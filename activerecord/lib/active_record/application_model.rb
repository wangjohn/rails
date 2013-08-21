require 'active_record/base'

module ActiveRecord
  class ApplicationModel < ActiveRecord::Base
    class << self
      attr_accessor :isolated

      def configs_from(mod)
        self.isolated = true

        mod.define_singleton_method(:application_model_namespace) { mod }

        application_model = self
        mod.define_singleton_method(:application_model) { application_model }
      end

      def get_config(name, context = self)
        mod = module_from_context(context)
        mod.send(name)
      end

      def set_config(name, value, context = self)
        mod = module_from_context(context)
        mod.send("#{name}=", value)
      end

      private

        def module_from_context(context)
          if context.respond_to?(:application_model)
            context.application_model
          elsif (parent_match = context.class.parents.detect { |m| m.respond_to?(:application_model) })
            parent_match.application_model
          else
            ActiveRecord::Base
          end
        end
    end
  end
end
