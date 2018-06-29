require "batali"
require "fileutils"
require "tmpdir"

module Batali
  # Source of asset
  class Source
    # Path based source
    class Git < Path
      include Bogo::Memoization
      include Batali::Git

      attribute :subdirectory, String, :equivalent => true
      attribute :path, String

      def initialize(*_, &block)
        super
        self.subdirectory = Utility.clean_path(subdirectory)
        self.path = Utility.clean_path(path)
      end

      def synchronize
        self.class.path_lock(path) do
          yield
        end
      end

      # @return [String] directory containing contents
      def asset
        clone_repository
        clone_path = ref_dup
        self.path = Utility.join_path(*[ref_dup, subdirectory].compact)
        result = super
        self.path = clone_path
        result
      end

      # Overload to remove non-relevant attributes
      def to_json(*args)
        MultiJson.dump(
          Smash.new(
            :url => url,
            :ref => ref,
            :type => self.class.name,
            :subdirectory => subdirectory,
          ), *args
        )
      end
    end
  end
end
