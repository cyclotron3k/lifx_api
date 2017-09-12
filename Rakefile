require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
	t.libs << "test"
	t.libs << "lib"
	t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test

desc "Launch an interactive Pry console"
task :console do
	exec "pry -r lifx_api -I ./lib"
end