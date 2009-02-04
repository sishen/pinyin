require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'
require 'rake/testtask'

NAME = "pinyin"
VERS = "0.1.0"

PKG_FILES = FileList[
  "lib/*", "Rakefile", "[A-Z]*"
]

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = VERS
  s.author = "Ye Dingding"
  s.email = "yedingding@gmail.com"
  s.homepage = "http://sishen.lifegoo.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "Turn chinese to pinyin(pronunciation)"
  s.files = PKG_FILES.to_a
  s.require_path = "lib"
  s.autorequire = "pinyin"
  s.test_file = "tests/ts_pinyin.rb"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

desc "Default Task"
task :default => [ :test ]

# Run the unit tests
desc "Run all unit tests"
Rake::TestTask.new("test") { |t|
  t.libs << "lib"
  t.pattern = 'tests/**/ts_*.rb'
  t.verbose = true
}

task :install do
  sh %{rake pkg/#{NAME}-#{VERS}.gem}
  sh %{sudo gem install pkg/#{NAME}-#{VERS}.gem}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
