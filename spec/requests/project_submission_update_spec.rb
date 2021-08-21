require 'rails_helper'

RSpec.describe 'Project Submission', type: :request do
  describe 'PATCH update' do
    context 'when the project submission has a discard_at date' do
      let(:project_submission) { create(:project_submission, user: user, discard_at: 7.days.from_now) }
      let(:user) { create(:user) }

      before do
        sign_in user
        allow_any_instance_of(ActionController::Base).to receive(:protect_against_forgery?).and_return(false)
      end

      it 'sets the discard_at column to nil' do
        patch project_submission_path(project_submission),
              params: { id: project_submission.id, project_submission: { repo_url: 'https://www.updated_url.com' } }

        expect(project_submission.reload.discard_at).to be_nil
      end
    end
  end
end
