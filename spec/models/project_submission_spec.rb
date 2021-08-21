require 'rails_helper'

RSpec.describe ProjectSubmission, type: :model do
  subject { create(:project_submission) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:lesson) }
  it { is_expected.to have_many(:flags) }

  it { is_expected.to validate_presence_of(:repo_url).with_message('Required') }
  it { is_expected.to allow_value('http://www.github.com/fff').for(:repo_url) }
  it { is_expected.to allow_value('https://www.github.com/fff').for(:repo_url) }
  it { is_expected.to_not allow_value('not_a_url').for(:repo_url) }

  it { is_expected.to allow_value('http://www.github.com/fff').for(:live_preview_url) }
  it { is_expected.to allow_value('https://www.github.com/fff').for(:live_preview_url) }
  it { is_expected.to_not allow_value('not_a_url').for(:live_preview_url) }

  describe '.viewable' do
    let!(:banned_project_submission) { create(:project_submission, banned: true) }
    let!(:private_project_submission) { create(:project_submission, is_public: false) }
    let!(:soft_deleted_project_submission)   { create(:project_submission, discarded_at: Time.zone.today) }
    let!(:viewable_project_submission_one)   { create(:project_submission) }
    let!(:viewable_project_submission_two)   { create(:project_submission) }

    it 'returns viewable project submissions' do
      expect(ProjectSubmission.viewable).to contain_exactly(
        viewable_project_submission_one,
        viewable_project_submission_two
      )
    end
  end

  describe '.created_today' do
    let!(:project_submission_created_today) do
      create(:project_submission, created_at: Time.zone.today)
    end

    let!(:project_submission_not_not_created_today) do
      create(:project_submission, created_at: Time.zone.today - 2.days)
    end

    it 'returns projects submission created today' do
      expect(ProjectSubmission.created_today).to contain_exactly(project_submission_created_today)
    end
  end

  describe '.discardable' do
    context 'when the project submission discard_at date is in the past' do
      let(:project_submission) { create(:project_submission, discard_at: 8.days.ago) }

      it 'returns a list including the project submission' do
        expect(described_class.discardable).to include(project_submission)
      end
    end

    context 'when the project submission discard_at date is in the future' do
      let(:project_submission) { create(:project_submission, discard_at: 1.day.from_now) }

      it 'returns a list not including the project submission' do
        expect(described_class.discardable).not_to include(project_submission)
      end
    end

    context 'when the project submission discard_at date is today' do
      let(:project_submission) { create(:project_submission, discard_at: 5.minutes.ago) }

      it 'returns a list including the project submission' do
        expect(described_class.discardable).to include(project_submission)
      end
    end

    context 'when the project submission discard_at date is nil' do
      let(:project_submission) { create(:project_submission, discard_at: nil) }

      it 'returns a list not including the project submission' do
        expect(described_class.discardable).not_to include(project_submission)
      end
    end

    context 'when the project_submission is not viewable' do
      let(:project_submission) do
        create(:project_submission, banned: true, discarded_at: 10.days.ago, is_public: false, discard_at: 6.days.ago)
      end

      it 'returns a list not including the project submission' do
        expect(described_class.discardable).not_to include(project_submission)
      end
    end
  end
end
