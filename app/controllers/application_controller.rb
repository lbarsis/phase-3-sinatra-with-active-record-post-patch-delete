require 'pry'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  delete '/reviews/:id' do 
    # find the review using the ID
    review = Review.find(params[:id])
    # delete the review
    review.destroy
    # send a response with the deleted review as JSON
    review.to_json
  end

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  post '/reviews' do
    # binding.pry
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )
    review.to_json
  end

  patch '/reviews/:id' do
    new_review = Review.find(params[:id])
    new_review.update(
      score: params[:score],
      comment: params[:comment]
    )
    new_review.to_json
  end

end
