require 'spec_helper'

describe User do
  it { should have_many :events }
  it { should have_many :todos}
end
