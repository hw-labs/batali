require 'batali'

module Batali
  # Source of asset
  class Source < Grimoire::Utility

    autoload :Path, 'batali/source/path'
    autoload :Site, 'batali/source/site'
    autoload :Git, 'batali/source/git'

    attribute :type, String, :required => true, :default => lambda{ self.name }

    # @return [VERSION_CLASS]
    def unit_version
      raise NotImplementedError.new 'Abstract class'
    end

    # @return [Grimoire::RequirementList]
    def unit_dependencies
      raise NotImplementedError.new 'Abstract class'
    end

    # @return [String] directory containing contents
    def asset
      raise NotImplementedError.new 'Abstract class'
    end

    # Build a source
    #
    # @param args [Hash]
    # @return [Source]
    # @note uses `:type` to build concrete source
    def self.build(args)
      type = args.delete(:type)
      unless(type)
        raise ArgumentError.new 'Missing required option `:type`!'
      end
      unless(type.to_s.include?('::'))
        type = [self.name, Bogo::Utility.camel(type)].join('::')
      end
      Bogo::Utility.constantize(type).new(args)
    end

  end
end