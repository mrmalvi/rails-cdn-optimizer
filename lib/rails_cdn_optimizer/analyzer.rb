require 'find'
require 'pathname'
require 'json'

module RailsCdnOptimizer
  class Analyzer
    attr_reader :asset_path, :cdn_host, :max_asset_size_kb

    def initialize(asset_path: "app/assets", cdn_host: nil, max_asset_size_kb: 500)
      @asset_path = Pathname.new(asset_path)
      @cdn_host = cdn_host
      @max_asset_size_kb = max_asset_size_kb
    end

    # Analyze all files in asset_path
    def analyze
      report = []

      return report unless asset_path.exist?

      Find.find(asset_path.to_s) do |file|
        next unless File.file?(file)

        size_kb = (File.size(file).to_f / 1024).round(2)
        suggestion = size_kb > max_asset_size_kb ? "Consider optimizing" : "OK"
        cdn_header = cdn_host ? "Cache-Control: max-age=31536000, immutable" : "Not configured"

        report << {
          path: Pathname.new(file).relative_path_from(asset_path).to_s,
          size_kb: size_kb,
          suggestion: suggestion,
          cdn_header: cdn_header
        }
      end

      report
    end

    # Generate JSON report
    def generate_json_report(file = "cdn_report.json")
      report = analyze
      File.write(file, JSON.pretty_generate(report))
      file
    end
  end
end
