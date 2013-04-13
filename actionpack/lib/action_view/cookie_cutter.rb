module ActionView
  class CookieCutter
    class << self
      def inherited(base)
        base.instance_variable_set("@_abstract_cookie_cutter", AbstractCookieCutter.new)
      end
    end

    def render_and_match(&block)
      @_abstract_cookie_cutter.render_and_match(&block)
    end

    def match(method_name, options = {})
      @_abstract_cookie_cutter.match(method_name, options = {})
    end

    def attach_partial(path)
      @_abstract_cookie_cutter.attach_partial(path)
    end
  end

  class AbstractCookieCutter
    def initialize
      @matches = {}
    end

    def render_and_match(&block)
      text = block_to_text(block)
      @matches.each do |method_name, options|
        result = public_send(method_name)

        if match = match_with_options(options, block)
          text = inject_match!(text, match)
        end
      end

      render :text
      raise "Implementation not completed"
    end

    def match(method_name, options = {})
      @matches[method_name] = options
    end

    def attach_partial(path)
      raise "Not implemented"
    end
  end
end
