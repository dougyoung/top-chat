require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before { Timecop.freeze }
  after { Timecop.return }

  describe 'GET #index' do
    let(:today) { Date.today.to_datetime }

    def do_action(params={})
      get :index, params
    end

    it 'responds successfully' do
      do_action
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      do_action
      expect(response).to render_template(:index)
    end

    describe 'parameters' do
      context 'none' do
        it 'assigns realtime events for today' do
          event = create(:event, created_at: today)
          do_action
          expect(assigns(:events)).to match_array([event])
          assigns(:events).each do |event|
            expect(event).to be_decorated_with EventDecorator
          end
        end
      end

      context 'with start date' do
        let(:params) do
          { start_date: { year: today.year, month: today.month, day: today.day - 1 } }
        end

        it 'assigns realtime events for the requested day' do
          event_yesterday = create(:event, created_at: today - 1.day)
          event_today = create(:event, created_at: today)
          do_action params
          expect(assigns(:events)).to match_array([event_yesterday])
          assigns(:events).each do |event|
            expect(event).to be_decorated_with EventDecorator
          end
        end
      end

      context 'with interval' do
        context 'invalid' do
          let(:params) do
            { interval: 'invalid' }
          end

          it 'assigns an error' do
            do_action params
            expect(assigns(:errors).count).to eq(1)
            expect(assigns(:errors).join).to include params[:interval]
          end
        end

        context 'hour' do
          let(:params) do
            { interval: :hour }
          end

          it 'assigns hourly events for today' do
            event_yesterday = create(:event, created_at: today - 1.day)
            event_today = create(:event, created_at: today)
            event_today_later = create(:event, created_at: today + 1.hour)
            do_action params
            expect(assigns(:events).count).to eq(2)
            assigns(:events).each do |event|
              expect(event).to be_decorated_with EventReportDecorator
            end
          end
        end
      end
    end
  end
end
