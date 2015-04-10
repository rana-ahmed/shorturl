class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links/new
  def new
    @link = Link.new
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)

    if Link.where(:link => @link.link).present?
      @link = Link.where(link: @link.link).take
      @notice = "your shorted link"
      render "show" and return
    end

    @link.shortlink = randomString

    respond_to do |format|
      if @link.save
        @notice = "your shorted link"
        format.html { render "show" }
        format.json { render "show", status: :created, location: @link, notice: 'your shorted link' }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def shortProcess
    @link = Link.where(:shortlink => params[:id]).take
    if @link
      @click = @link.clicks.new
      @click.browser = browser.name
      @click.os = browser.platform
      @click.save
      redirect_to @link.link
    else
      show_404
    end
  end

  def analytics
    if params[:url]
      url = params[:url].delete(' ')
      if url.start_with?(root_url)
        shortlink = url.split(root_url)[1]
        @data = Link.where(:shortlink => shortlink).take
        if @data
          render "report"
        else
          show_404
        end
      else
        show_404
      end
    else
      show_404
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through
    def link_params
      params.require(:link).permit(:link)
    end

    def show_404
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end

    #generating random string
    def randomString
      letterAndNumbers = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
      ranadomLetterAndNumbers = (0...5).map { letterAndNumbers[rand(letterAndNumbers.length)] }.join
      if Link.where(:shortlink => ranadomLetterAndNumbers).present?
        randomString
      else
        return ranadomLetterAndNumbers
      end
    end
end
