class PropertiesController < ApplicationController
  before_action :require_login!, only: [:create, :destroy, :update, :get_user]
  before_action :set_s3_client

  def get_user
    @user = User.find(params[:id])
    render json: @user.as_json(only: [:phone, :email, :name])
  end

  def index
    @properties = Property.all
    properties_with_url = []
    @properties.each do |property|
      property_with_url = { property: property }
      if(property.images.attached?)
        url = []
        i=0
        property.images.each do |_image|
          object = @s3.bucket("getahome").object(property.images[i].blob.key)
          i = i +1 
          url.push(object.presigned_url(:get, expires_in: 3600))
        end
      else
        url="sin imagen"
      end
      property_with_url[:url] = url
      properties_with_url << property_with_url
    end

    render json: properties_with_url
  end

  def create
    @property = Property.new(property_params)
    @property.user_id = current_user.id
    if @property.save
      # @property.images.attach(params[:property][:images])
      url = []
      i=0
      if(property.images.attached?)
        property.images.each do |_image|
          object = @s3.bucket("getahome").object(property.images[i].blob.key)
          i = i +1 
          url.push(object.presigned_url(:get, expires_in: 3600))
        end
      else
        url = "sin imagen"
      end
      
      render json: {property:@property, url: url}, status: :created
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end
  
  def show
    @property = Property.find(params[:id])
    url=[]
    i=0
    if !@property.images.attached?
      render json: { property: @property, url: "sin imagen" }
    else
      @property.images.each do |_image|
        object = @s3.bucket("getahome").object(@property.images[i].blob.key)
        i = i +1 
        url.push(object.presigned_url(:get, expires_in: 3600))
      end
      # object = @s3.bucket("getahome").object(@property.images.blob.key)
      render json: { property: @property, url: url }
    end
  end
  
  def update
    @property = Property.find(params[:id])
    if @property.update(property_params)
      render json:@property.as_json(except: [:password_digest])
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy
    head :no_content
  end
  
  private

  def set_s3_client
    @s3 = Aws::S3::Resource.new(region: "us-east-1",
      access_key_id: "AKIAYDOFGOCUH2II6ZMY",
      secret_access_key: "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")
  end

  def property_params
    params.require(:property).permit(:bedrooms, :bathrooms, :area, :pet_allowed,
                                      :description, :price, :mode, :property_type, :status, :maintenance, {images:[]}, :district, :province, :latitud, :longitud)
  end
end
