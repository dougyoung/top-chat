require 'rails_helper'

shared_examples_for 'reportable intervals' do
  let(:model) { described_class }

  before { Timecop.freeze }
  after { Timecop.return }

  describe 'reports' do
    let(:start_hour) { DateTime.now.utc.at_beginning_of_hour }
    let(:next_hour) { DateTime.now.utc.at_end_of_hour + 1.second }

    subject { model.report(start_hour, next_hour + 1.second) }
    let(:first_report) { subject.first }

    describe 'matching by date range' do
      it 'is empty when there are no records' do
        expect(subject).to be_empty
      end

      it 'is empty when no records exist in date range' do
        create(:event, created_at: start_hour - 1.second)
        create(:event, created_at: next_hour + 1.second)
        expect(subject).to be_empty
      end

      it 'has results when records exist in date range' do
        create(:event, created_at: start_hour)
        expect(subject.count).to eq(1)
      end
    end

    describe 'grouping actions by hours' do
      it 'does not group the same actions in different hours' do
        create(:event, created_at: start_hour)
        create(:event, created_at: next_hour)
        expect(first_report[:events].count).to eq(1)
        expect(first_report[:events].first[:count]).to eq(1)
      end

      it 'does not group different actions in different hours' do
        create(:event, :enter_the_room, created_at: start_hour)
        create(:event, :leave_the_room, created_at: next_hour)
        expect(first_report[:events].count).to eq(1)
        expect(first_report[:events].first[:count]).to eq(1)
      end

      it 'groups the same actions in the same hour' do
        create(:event, created_at: start_hour)
        create(:event, created_at: next_hour - 1.second)
        expect(first_report[:events].count).to eq(1)
        expect(first_report[:events].first[:count]).to eq(2)
      end

      it 'groups different actions in the same hour' do
        create(:event, :enter_the_room, created_at: start_hour)
        create(:event, :leave_the_room, created_at: next_hour - 1.second)
        expect(first_report[:events].count).to eq(2)
        expect(first_report[:events].first[:count]).to eq(1)
      end
    end

    describe 'grouping <action, hour> documents by hour' do
      it 'does not group documents in different hours' do
        create(:event, created_at: start_hour)
        create(:event, created_at: next_hour)
        expect(subject.count).to eq(2)
      end

      it 'groups documents in the same hour' do
        create(:event, created_at: start_hour)
        create(:event, created_at: next_hour - 1.second)
        expect(subject.count).to eq(1)
      end

      it 'counts unique receivers per event type' do
        create(:event, created_at: start_hour, sender: 'sender', receiver: 'receiver_one')
        create(:event, created_at: start_hour, sender: 'sender', receiver: 'receiver_two')
        expect(first_report[:events].first[:senders]).to eq(1)
        expect(first_report[:events].first[:receivers]).to eq(2)
      end

      it 'counts unique senders per event type' do
        create(:event, created_at: start_hour, sender: 'sender_one', receiver: 'receiver')
        create(:event, created_at: start_hour, sender: 'sender_two', receiver: 'receiver')
        expect(first_report[:events].first[:senders]).to eq(2)
        expect(first_report[:events].first[:receivers]).to eq(1)
      end
    end

    describe 'sorting' do
      it 'sorts reports by hour' do
        create(:event, created_at: start_hour)
        create(:event, created_at: next_hour)
        expect(subject.first[:_id]).to be < subject.second[:_id]
      end
    end
  end
end
