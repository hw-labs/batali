require "batali"
require "fileutils"

module Batali
  class Command

    # Install cookbooks based on manifest
    class Install < Batali::Command

      # Install cookbooks
      def execute!
        dry_run("Cookbook installation") do
          install_path = Utility.clean_path(config.fetch(:path, "cookbooks"))
          run_action("Readying installation destination") do
            FileUtils.rm_rf(install_path)
            FileUtils.mkdir_p(install_path)
            nil
          end
          if manifest.cookbook.nil? || manifest.cookbook.empty?
            ui.error "No cookbooks defined within manifest! Try resolving first. (`batali resolve`)"
          else
            run_action("Installing cookbooks") do
              manifest.cookbook.each_slice(100) do |units_slice|
                units_slice.map do |unit|
                  Thread.new do
                    ui.debug "Starting unit install for: #{unit.name}<#{unit.version}>"
                    ui.debug "Unit source: #{unit.source.inspect}"
                    unit.source.synchronize do
                      if unit.source.respond_to?(:cache_path)
                        unit.source.cache_path = cache_directory(
                          Bogo::Utility.snake(unit.source.class.name.split("::").last)
                        )
                      end
                      asset_path = unit.source.asset
                      final_path = Utility.join_path(install_path, unit.name)
                      if infrastructure?
                        final_path << "-#{unit.version}"
                      end
                      begin
                        FileUtils.cp_r(
                          Utility.join_path(asset_path, "."),
                          final_path
                        )
                        ui.debug "Completed unit install for: #{unit.name}<#{unit.version}>"
                      rescue => e
                        ui.debug "Failed unit install for: #{unit.name}<#{unit.version}> - #{e.class}: #{e}"
                        raise
                      ensure
                        unit.source.clean_asset(asset_path)
                      end
                    end
                  end
                end.map(&:join)
              end
              nil
            end
          end
        end
      end
    end
  end
end
