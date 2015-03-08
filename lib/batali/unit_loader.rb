require 'batali'

module Batali

  class UnitLoader < Utility

    attribute :file, BFile, :required => true
    attribute :system, Grimoire::System, :required => true

    # Populate the system with units
    #
    # @return [self]
    def populate!
      memoize(:populate) do
        file.source.each do |src|
          src.units.find_all do |unit|
            if(restrictions[unit.name])
              restriction[unit.name] == src.identifier
            else
              true
            end
          end.each do |unit|
            system.add_unit(unit)
          end
        end
        file.cookbook.each do |ckbk|
          if(ckbk[:path])
            source = Origin::Path.new(
              :path => ckbk[:path]
            )
          elsif(ckbk[:git])
            source = Origin::Git.new(
              :url => ckbk[:git],
              :ref => ckbk[:ref]
            )
          end
          if(source)
            system.add_unit(source.units.first)
          end
        end
      end
    end

    # @return [Smash]
    def restrictions
      memoize(:restrictions) do
        rest = file.restrict.dup
        file.cookbook.each do |name, ckbk|
          if(ckbk[:path])
            rest[name] = Smash.new(:path => ckbk[:path]).checksum
          elsif(ckbk[:git])
            rest[name] = Smash.new(
              :url => ckbk[:git],
              :ref => ckbk[:ref]
            ).checksum
          end
        end
        rest
      end
    end

  end

end