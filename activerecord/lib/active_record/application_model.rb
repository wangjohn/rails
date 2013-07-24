module ActiveRecord
  module ApplicationModel
    class ModelConfiguration
      attr_accessor :ordered_options

      def initialize(ordered_options = nil)
        @ordered_options = ordered_options || create_defaults
      end

      def method_missing(name, *args)
        self.class.create_accessor(name)
        send(name)
      end

      def respond_to_missing?(name, include_private)
        true
      end

      private

        def self.create_accessor(name, *args)
          define_method(name) do |*args|
            @ordered_options.send(name, *args)
          end
        end

        def create_defaults
          ActiveSupport::OrderedOptions.new(
            logger:                                   nil,
            primary_key_prefix_type:                  nil,
            table_name_prefix:                        "",
            table_name_suffix:                        "",
            pluralize_table_names:                    true,
            configurations:                           {},
            default_timezone:                         :utc,
            schema_format:                            :ruby,
            timestamped_migrations:                   true,
            default_connection_handler:               ConnectionAdapters::ConnectionHandler.new,
            time_zone_aware_attributes:               false,
            skip_time_zone_conversion_for_attributes: [],

            #TODO: find out if we actually use these
            lock_optimistically:                      nil,
            cache_timestamp_format:                   nil
          )
        end
    end

    mattr_accessor :config
    self.config = ModelConfiguration.new
  end
end
