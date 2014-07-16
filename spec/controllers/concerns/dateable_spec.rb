require 'rails_helper'

class DateableController < ActionController::Base
  include Dateable
end

RSpec.describe DateableController, type: :controller do
  before { Timecop.freeze }
  after { Timecop.return }

  it 'returns today if input is blank' do
    expect(subject.datetime_or_default(nil)).to eq Date.today.to_datetime
  end

  it 'returns today if any of the key values is blank' do
    expect(subject.datetime_or_default({ year: 0, month: nil })).to eq Date.today.to_datetime
  end

  it 'returns date determined from the order of keys' do
    expect(subject.datetime_or_default({ any: 0, keys: 1, here: 2 })).to eq DateTime.civil(0, 1, 2)
  end
end
