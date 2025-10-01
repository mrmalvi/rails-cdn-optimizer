# RailsCdnOptimizer

[![Gem Version](https://badge.fury.io/rb/rails-cdn-optimizer.svg)](https://badge.fury.io/rb/rails-cdn-optimizer)

RailsCdnOptimizer analyzes your Rails app's asset pipeline, detects large files, and suggests CDN caching rules to improve performance.

---

## Features

- Analyze `app/assets`, `lib/assets`, and `vendor/assets`
- Detect large files that may slow down page load
- Suggest caching headers for CDN optimization
- Generate JSON report for integration with monitoring tools
- Easy integration with Rake tasks

---

## Installation

Add this line to your Gemfile:

```ruby
gem 'rails-cdn-optimizer'

```

## Usage

Rake Task

Generate a CDN analysis report:

bundle exec rake cdn:analyze


RailsCdnOptimizer.configure do |config|
  config.cdn_host = "https://cdn.yourdomain.com"
end

ASSET_PATH=spec/tmp_assets bundle exec rake cdn:analyze


[
  {
    "path": "application.js",
    "size_kb": 512,
    "suggestion": "Consider optimizing",
    "cdn_header": "Cache-Control: max-age=31536000, immutable"
  },
  {
    "path": "style.css",
    "size_kb": 120,
    "suggestion": "OK",
    "cdn_header": "Cache-Control: max-age=31536000, immutable"
  }
]


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rails-cdn-optimizer.
# rails-cdn-optimizer
