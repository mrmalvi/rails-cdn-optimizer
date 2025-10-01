require 'spec_helper'
require 'rake'
require 'json'

# Load Rake and task
Rake.application = Rake::Application.new
load File.expand_path("../../../lib/tasks/cdn_optimizer.rake", __FILE__)
Rake::Task.define_task(:environment)

RSpec.describe "cdn:analyze" do
  tmp_dir = "spec/tmp_assets"

  before(:context) do
    FileUtils.mkdir_p(tmp_dir)
    File.write("#{tmp_dir}/small.js", "console.log('hello');")
    File.write("#{tmp_dir}/large.js", "x" * 600 * 1024)

    RailsCdnOptimizer.configure do |config|
      config.cdn_host = "https://cdn.test.com"
    end
  end

  after(:context) do
    FileUtils.rm_rf(tmp_dir)
    FileUtils.rm_f("cdn_report.json")
  end

  it "runs the rake task and generates a report" do
    allow(RailsCdnOptimizer::Analyzer).to receive(:new)
      .and_return(RailsCdnOptimizer::Analyzer.new(
        asset_path: "spec/tmp_assets",
        cdn_host: RailsCdnOptimizer.config.cdn_host
      ))

    Rake::Task["cdn:analyze"].reenable
    expect { Rake::Task["cdn:analyze"].invoke }.to output(/Report generated: cdn_report.json/).to_stdout

    expect(File.exist?("cdn_report.json")).to be true
    report = JSON.parse(File.read("cdn_report.json"))

    expect(report.size).to eq(2)
    small = report.find { |r| r["path"] == "small.js" }
    large = report.find { |r| r["path"] == "large.js" }

    expect(small["suggestion"]).to eq("OK")
    expect(large["suggestion"]).to eq("Consider optimizing")
    expect(small["cdn_header"]).to eq("Cache-Control: max-age=31536000, immutable")
  end
end
