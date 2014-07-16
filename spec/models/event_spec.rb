require 'rails_helper'

RSpec.describe Event, type: :model do
  it_should_behave_like 'reportable intervals'
end
