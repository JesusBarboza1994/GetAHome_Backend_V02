class PropertiesController < ApplicationController
  before_action :require_login!, only: [:create, :destroy, :update]
  before_action :set_s3_client

  def index
    @properties = Property.all
    properties_with_url = []
    @properties.each do |property|
      property_with_url = { property: property }
      if(property.image.attached?)
        object = @s3.bucket("getahome").object(property.image.blob.key)
        url = object.presigned_url(:get, expires_in: 3600)
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
      @property.image.attach(params[:image])  
      puts "SALIOOOO" if @property.image.attached?
      render json: @property, status: :created
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end
  
  def show
    @property = Property.find(params[:id])
    if @property.image.attached?
      render json: { property: @property, url: "sin imagen" }
    else
      object = @s3.bucket("getahome").object(@property.image.blob.key)
      render json: { property: @property, url: object.presigned_url(:get, expires_in: 3600) }
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
                                      :description, :price, :mode, :address, :property_type, :status, :maintenance, :image)
  end
end
