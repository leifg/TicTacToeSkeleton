# GamesController_controller_spec

require 'rails_helper'

describe GamesController do
  describe "games#index" do
    before(:each) do
      get :index
    end

    it "should set the @games instance variable to a set of all Games" do
      expect(assigns[:games]).not_to be_nil
      expect(assigns[:games].all? {|game| game.kind_of?(Game)}).to be_true
    end
  end

  describe "games#new" do
    let(:request) { get :new }

    it "should set the @game variable to a new game" do
      request
      expect(assigns[:game].try(:kind_of?, Game)).to be_true
    end

    it "should create and save a new game in the database" do
     expect { request }.to change(Game, :count).by(1)
    end

    it "should redirect to show" do
      expect(request).to redirect_to(game_path(Game.last.id))
    end

   end

  describe "games#show" do
    describe 'with valid params' do
      before(:each) do
        g = Game.new
        g.save

        @game_id = g.id
        get :show, :id => @game_id
      end

      it 'should set the @game instance variable' do
        expect(assigns[:game].try(:kind_of?, Game)).to be_true
        expect(assigns[:game]).to eq(Game.find(@game_id))
      end
    end

    describe 'with invalid params' do
      invalid_id = Game.last.nil? ? 1 : (Game.last.id + 1)
      let(:request) { get :show, :id => 1 }

      it "should not create a new game object" do
        expect_any_instance_of(Game).not_to receive(:initalize)
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should not create a new game in the database" do
        # need to nest the expect so we don't crash before checking count
        expect { expect { request }.to raise_error(ActiveRecord::RecordNotFound) }.not_to change(Game, :count)
      end

    end
  end

  describe "games#update" do
   let(:request) { put :update, :id => @game.id, :game => { :row => 0, :column => 1 } }

    before(:each) do
      @game = Game.new
      @game.save!
    end

    it "should enter a value into the board" do
      expect_any_instance_of(Game).to receive(:play).with(0,1)
      request
    end

    it "should redirect to show" do
      expect(request).to redirect_to(game_path(Game.last.id))
    end
  end
end
