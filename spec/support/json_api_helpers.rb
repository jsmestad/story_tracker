module StoryTracker
  module RSpec
    module JsonApiHelpers

      def json_response
        JSON.parse response.body
      end

      def be_an_empty(klass)
        be_a(klass).and(be_empty)
      end

      def all_match(*args)
        all match(*args)
      end

    end
  end
end

RSpec.configure do |c|
  c.include StoryTracker::RSpec::JsonApiHelpers, type: :request
end
