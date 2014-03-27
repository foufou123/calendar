require 'spec_helper'

describe Todo do
  it { should belong_to :user }
  it { should have_many :notes }
end
