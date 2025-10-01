require "rails_cdn_optimizer/analyzer"
require "fileutils"

RSpec.describe RailsCdnOptimizer::Analyzer do
  let(:tmp_dir) { "spec/tmp_assets" }

  before(:each) do
    FileUtils.mkdir_p(tmp_dir)
    File.write("#{tmp_dir}/small.js", "console.log('hello');")
    File.write("#{tmp_dir}/large.js", "x" * 600 * 1024) # 600KB
  end

  after(:each) do
    FileUtils.rm_rf(tmp_dir)
    FileUtils.rm_f("cdn_report.json")
  end

  it "analyzes assets and detects large files" do
    analyzer = described_class.new(asset_path: tmp_dir, max_asset_size_kb: 500, cdn_host: "https://cdn.test.com")
    report = analyzer.analyze

    expect(report).to be_a(Array)
    expect(report.size).to eq(2)

    small_file = report.find { |r| r[:path] == "small.js" }
    large_file = report.find { |r| r[:path] == "large.js" }

    expect(small_file[:suggestion]).to eq("OK")
    expect(large_file[:suggestion]).to eq("Consider optimizing")
    expect(small_file[:cdn_header]).to eq("Cache-Control: max-age=31536000, immutable")
  end

  it "generates a JSON report file" do
    analyzer = described_class.new(asset_path: tmp_dir, cdn_host: "https://cdn.test.com")
    file = analyzer.generate_json_report("cdn_report.json")

    expect(File.exist?(file)).to be true
    json = JSON.parse(File.read(file))
    expect(json).to be_a(Array)
    expect(json.size).to eq(2)
  end
end
