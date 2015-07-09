require 'tracker_api'

module TrackerApi
  module Resources
    class Iteration
      def is_current?
        start < DateTime.now && finish > DateTime.now
      end

      def is_future?
        finish > DateTime.now && start > DateTime.now
      end

      def is_past?
        finish < DateTime.now
      end

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
