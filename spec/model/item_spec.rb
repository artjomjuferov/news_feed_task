require 'rails_helper'

describe Item, type: :model do

  context 'when broken validation' do
    subject { Item.create }

    context 'when without geo' do
      it { is_expected.not_to be_valid }
    end

    context 'when without name' do
      it { is_expected.not_to be_valid }
    end
  end

  context 'when right values provided' do
    subject { Item.create name: 'name', geo: 1.1}

    it { is_expected.to be_valid }
  end

  context 'when set order_key' do
    after(:all) { clear_db }

    before(:all) do
      @order_key = Time.now.utc
      @item = Item.create name: 'name',
                          geo: 1.1,
                          order_key: @order_key
      @item.users << User.create
    end

    subject { @item.items_users.last.order_key.utc.to_s }

    context 'when add users to item' do
      it { is_expected.to eq @order_key.to_s }
    end

    context 'when update' do
      before(:all) do
        @order_key_updated = @order_key+1.minute
        @item.update_attribute :order_key, @order_key_updated
      end
      it { is_expected.to eq @order_key_updated.to_s }
    end
  end

  context 'class methods' do
    subject { Item }

    it { is_expected.to respond_to :get_on_page, :last_page }

    describe "#get_on_page" do

      subject { Item.get_on_page user_id, page }

      context 'when page_id is nil' do
        let(:page) { nil }
        context 'when wrong user_id' do
          ['-1', 'z','select * from info', -1].each do |wrong_id|
            let(:user_id) { wrong_id }

            it 'raises error' do
              expect{ subject }.to raise_error ArgumentError
            end
          end
        end

        context 'when correct user_id' do
          before(:all) do
            @user1 = User.create
            (Item::PER_PAGE+1).times do |i|
              item = Item.create name: "anonymous#{i}",
                                 geo: 1.1,
                                 order_key: Time.now+(Item::PER_PAGE-i).day
              item.users << @user1
            end
            @user2 = User.create
          end

          after(:all) { clear_db }

          context 'when user 1' do
            let(:user_id){ @user1.id }

            it 'returns array with right size ' do
              expect(subject.size).to eq Item::PER_PAGE
            end

            it 'returns array sorted by order_key' do
              #should be sorted by order_key it's opposite ещ id
              expect(subject).to eq subject.sort{|x,y| x.id <=> y.id }
            end
          end

          context 'when user 2' do
            let(:user_id){ @user2.id }
            it { is_expected.to eq [] }
          end

          context 'when user which does not exist' do
            let(:user_id){ 1234 }
            it { is_expected.to eq [] }
          end
        end
      end
    end


    describe "#last_page" do
      subject { Item.last_page user_id }

      context 'when wrong user_id' do
        ['-1', 'z','select * from info', -1].each do |wrong_id|
          let(:user_id) { wrong_id }
          it 'raises error' do
            expect{ subject }.to raise_error ArgumentError
          end
        end
      end

      context 'when correct user_id' do
        before(:all) do
          @user1 = User.create
          @user2 = User.create
          (Item::PER_PAGE+1).times do
              item  = Item.create name: 'anonymous', geo: 1.1
              item.users << @user1
          end
          item = Item.last
          item.users << @user2
        end

        after(:all) { clear_db }

        context 'when user 1' do
          let(:user_id){ @user1.id }
          it { is_expected.to eq 2 }
        end

        context 'when user 2' do
          let(:user_id){ @user2.id }
          it { is_expected.to eq 1 }
        end

        context 'when user which does not exist' do
          let(:user_id){ 1234 }
          it { is_expected.to eq 0 }
        end
      end
    end
  end

  private

  def clear_db
    User.destroy_all
    Item.destroy_all
  end
end