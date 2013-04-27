require 'spec_helper'

describe MoviesController do
  describe "edit page for a movie" do
    it 'When I go to the edit page to see a movie, that movie should be loadded' do
      movie = mock('Movie')
      Movie.should_receive(:find).with('1').and_return(movie)
      get :edit, {:id => '1'}
      response.should be_success
    end
    it "When I fill in Director and press Update Movie Info, the Director should be saved" do
      mock = mock('Movie')
      mock.stub!(:update_attributes!)
      mock.stub!(:title)
      mock.stub!(:director)
      mock.stub!(:director)
      
      mock2 = mock('Movie')
      
      Movie.should_receive(:find).with('13').and_return(mock)
      mock.should_receive(:update_attributes!)
      post :update, {:id => '13', :movie => mock2 }
    end
    it 'When I follow "Find Movies With Same Director", I should be on the Similar Movies page for the Movie' do
      mock = mock('Movie')
      mock.stub!(:director).and_return('mock director')
      
      similarMocks = [mock('Movie'), mock('Movie')]
      
      Movie.should_receive(:find).with('13').and_return(mock)
      Movie.should_receive(:find_all_by_director).with(mock.director).and_return(similarMocks)
      get :similar, {:id => '13'}
    end
    it 'should show Movie by id' do
      mock = mock('Movie')
      Movie.should_receive(:find).with('13').and_return(mock)
      get :show, {:id => '13'}
    end
    it 'should redirect to index if movie does not have a director' do
      mock = mock('Movie')
      mock.stub!(:director).and_return(nil)
      mock.stub!(:title).and_return(nil)
      
      Movie.should_receive(:find).with('13').and_return(mock)
      get :similar, {:id => '13'}
      response.should redirect_to(movies_path)
    end
    it 'should be possible to create movie' do
      movie = mock('Movie')
      movie.stub!(:title)
      
      Movie.should_receive(:create!).and_return(movie)
      post :create, {:movie => movie}
      response.should redirect_to(movies_path)
    end
    it 'should be possible to destroy movie' do
      movie = mock('Movie')
      movie.stub!(:title)
      
      Movie.should_receive(:find).with('13').and_return(movie)
      movie.should_receive(:destroy)
      post :destroy, {:id => '13'}
      response.should redirect_to(movies_path)
    end
    it 'should redirect if selected ratings are changed' do
      get :index, {:ratings => {:G => 1}}
      response.should redirect_to(movies_path(:ratings => {:G => 1}))
    end
    it 'should remove noDirector message from session' do
      session[:noDirector] = 'test'
      get :index
      session[:noDirector].should == nil
    end
    it 'should call database to get movies' do
      Movie.should_receive(:find_all_by_rating)
      get :index
    end
  end
end
