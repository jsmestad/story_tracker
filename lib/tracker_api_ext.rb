require 'tracker_api'

module TrackerApi
  module Resources
    class Iteration
      def to_param
        number.to_s
      end
    end

    class Story
      def to_param
        id.to_s
      end
    end
  end
end
