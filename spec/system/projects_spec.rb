require 'rails_helper'

RSpec.describe 'Projects', type: :system do
  let(:user) { create(:user) }

  before { login_as(user, :scope => :user) }

  describe 'プロジェクト登録機能' do
    let(:project) { build(:project) }

    it 'プロジェクト登録を正常に行えること' do
      visit new_project_path

      fill_in 'project[name]', with: project.name
      expect { click_on '作成' }.to change { Project.count }.by(1)

      expect(current_path).to eq projects_path
      expect(page).to have_content 'プロジェクトを作成しました。'
      expect(Project.last.users).to eq [user]
    end
  end

  describe 'ヘッダー' do
    let(:undone_project) { create(:project, is_done: false) }

    before do
      undone_project.users << user
      visit projects_path
    end

    it '自分が割り当てられた未完了プロジェクト名が表示されていること' do
      within '.offcanvas' do
        expect(page).to have_content undone_project.name
      end
    end
  end

  describe 'プロジェクト一覧ページ' do
    let(:undone_project) { create(:project, is_done: false) }

    before do
      undone_project.users << user
      visit projects_path
    end

    it '未完了プロジェクトの情報が表示されていること' do
      within '.card' do
        expect(page).to have_content undone_project.name
        expect(page).to have_content undone_project.description
        expect(page).to have_content user.name
      end
    end
  end
end
