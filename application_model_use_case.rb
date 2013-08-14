require 'active_support'
require 'active_record'

# In this example, we will use two different databases to access different models.
# The two databases will have different default configurations and hence their
# ActiveRecord configurations should be different as well.
module FirstApplication
  module ActiveRecord
    class FirstApplicationModel < ApplicationModel
      configs_from(FirstApplication)
    end
  end
end

# This is the second application. It launches its own version of ActiveRecord
module SecondApplication
  module ActiveRecord
    class SecondApplicationModel < ApplicationModel
      configs_from(SecondApplication)
    end
  end
end

FirstApplication::ActiveRecord
