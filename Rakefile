require "bundler/gem_tasks"
require "rake/testtask"
require "multi_json"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :schema do
  require "yaml"
  schema = YAML.load(File.open(File.join("schema", "schema.yaml")))
  File.open(File.join("schema", "schema.json"), "w") do |f|
    f.write(MultiJson.encode(schema, pretty: true))
  end
end

task :default => :test
