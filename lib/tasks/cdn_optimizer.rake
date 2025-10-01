require 'rake'
require_relative '../../lib/rails_cdn_optimizer/analyzer'

namespace :cdn do
  desc "Analyze assets and generate CDN report"
  task :analyze do
    analyzer = RailsCdnOptimizer::Analyzer.new(
      asset_path: "app/assets",
      cdn_host: RailsCdnOptimizer.config&.cdn_host
    )
    file = analyzer.generate_json_report
    puts "Report generated: #{file}"
  end
end
