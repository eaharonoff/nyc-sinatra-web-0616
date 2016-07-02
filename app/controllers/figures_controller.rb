require 'pry'
class FiguresController < ApplicationController
  
  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do
    @landmarks = Landmark.all
    @titles = Title.all
    #binding.pry
    erb :'figures/new'
  end

  post '/figures' do
    @figure = Figure.create(params["figure"])
    #binding.pry
    if params["figure"]["title_ids"].nil?
      @title = Title.create(name: params["title"]["name"])
      peef = FigureTitle.create(figure_id: @figure.id, title_id: @title.id)
    else
      params["figure"]["title_ids"].each do |title_id|
        FigureTitle.create({figure_id: @figure.id, title_id: title_id})
      end
    end

    if params["figure"]["landmark_ids"].nil?
      @landmark = Landmark.create(name: params["landmark"]["name"])
      @figure.landmarks << @landmark 
    end
    erb :'/figures/index'
  end

  get '/figures/:id' do 
    @figure = Figure.find(params[:id])
    erb :'/figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    erb :'/figures/edit'
  end

  post '/figures/:id' do 
    @figure = Figure.find(params[:id])
    @figure.update(params["figure"])
    if !params["title"]["name"].empty?
       @title = Title.create(name: params["title"]["name"])
       FigureTitle.find_or_create_by(figure_id: @figure.id, title_id: @title.id)
    else 
      params["figure"]["title_ids"].each do |title_id|
        FigureTitle.create({figure_id: @figure.id, title_id: title_id})
      end
    end
  end



end