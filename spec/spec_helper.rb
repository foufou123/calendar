require 'rspec'
require 'active_record'
require 'shoulda-matchers'
require 'event'
require 'user'
require 'todo'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Event.all.each { |class_object| class_object.destroy }
    User.all.each { |class_object| class_object.destroy }
    Todo.all.each { |class_object| class_object.destroy }
  end
end
