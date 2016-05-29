require 'rails_helper'

RSpec.describe FeedController, type: :controller  do

  describe 'GET index' do
    let(:visit) { get :index, user_id: 1 }

    it "renders the index template" do
      visit
      expect(response).to render_template :index
    end

    # it "assigns @last_page" do
    #   visit
    #   expect(assigns(:last_page)).to eq(10)
    # end
  end

  describe 'GET items' do
    let(:visit) { get :items, user_id: 1, page: 1 }

    let(:json) { JSON.parse(response.body) }

    it "renders json" do
      visit
      expect{ json }.not_to raise_error
    end

    it "renders right value" do
      allow(Item).to receive(:get_on_page).and_return [{
                                                           name: 'anonymous',
                                                           geo: 21321.231,
                                                           id: 1
                                                       }]
      allow(Item).to receive(:last_page).and_return(10)
      visit
      expect(json).to eq(
                          'items' => [{
                                          "name" => 'anonymous',
                                          "geo" => 21321.231,
                                          "id" => 1
                                      }],
                          'lastPage' => 10
                      )
    end
  end

end