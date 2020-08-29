require 'rest-client'
require 'nokogiri'
require 'open-uri'

class SongsController < ApplicationController
  before_action :set_song, only: [:show, :update, :destroy]

  def test 
    render plain: "Test"
  end 

  def lyrics
    song = params[:song]
    artist = params[:artist]
    token = "dsKmc8i46aTDrI04k4W4OkE3-fJBsnITVMl3ZZOpaxStMOpyE2x9dIpKVCjrdN1L"
    response = RestClient.get("https://api.genius.com/search?q=#{song}%20#{artist}", {
        "User-Agent": "CompuServe Classic/1.22",
        "Accept": "application/json",
        "Host": "api.genius.com",
        "Authorization": "Bearer #{token}"
    })
    
    json_body = JSON.parse(response.body)

    song_url = json_body["response"]["hits"][0]["result"]["url"]

    doc = Nokogiri::HTML(open(song_url))
    
    lyrics = {lyrics: doc.css(".lyrics").children[3].text, website: song_url}
        
    render json: lyrics 
  end 

  # GET /songs
  def index
    @songs = Song.all

    render json: @songs
  end

  # GET /songs/1
  def show
    render json: @song
  end

  # POST /songs
  def create
    @song = Song.new(song_params)

    if @song.save
      render json: @song, status: :created, location: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /songs/1
  def update
    if @song.update(song_params)
      render json: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  # DELETE /songs/1
  def destroy
    @song.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def song_params
      params.require(:song).permit(:title)
    end
end
