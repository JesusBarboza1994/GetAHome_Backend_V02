class InvolvedPropertiesController < ApplicationController
  rescue_from PG::UniqueViolation, with: :duplicate_involved_property
  before_action :require_login!
  before_action :set_s3_client
  def index
    @favorites = current_user.properties.where(involved_properties: {favorite: true})
    
    @contacts = current_user.properties.where(involved_properties: {contacts: true})
    favorites_with_url = []
    contacts_with_url = []
   
    @favorites.each do |favorite|
      favorite_with_url = { property: favorite }
      if !favorite.images.attached?
        url = "sin imagen"
      else
        url = []
        i=0
        favorite.images.each do |_image|
          object = @s3.bucket("get-a-home").object(favorite.images[i].blob.key)
          i = i +1 
          url.push(object.presigned_url(:get, expires_in: 3600))
        end
        # object = @s3.bucket("get-a-home").object(favorite.images[0].blob.key)
        # url = object.presigned_url(:get, expires_in: 3600)
      end
      favorite_with_url[:url] = url
      favorites_with_url << favorite_with_url
    end

    @contacts.each do |contact|
      contact_with_url = { property: contact }
      if !contact.images.attached?
        url = "sin imagen"
      else
        url = []
        i=0
        contact.images.each do |_image|
          object = @s3.bucket("get-a-home").object(contact.images[i].blob.key)
          i = i +1 
          url.push(object.presigned_url(:get, expires_in: 3600))
        end

        # object = @s3.bucket("get-a-home").object(contact.images[0].blob.key)
        # url = object.presigned_url(:get, expires_in: 3600)
      end
      contact_with_url[:url] = url
      contacts_with_url << contact_with_url
    end

    render json: { favorites: favorites_with_url, contacts: contacts_with_url}
  end

  def create
    @property = Property.find(params[:property_id])
    inv = InvolvedProperty.where(user:current_user, property:@property)

    if !(inv.length === 0)
      update
    else
      if !params[:contacts].nil?
        @involved_property = InvolvedProperty.new(
          user: current_user, property: @property, favorite:false, contacts: params[:contacts])  
      elsif !params[:favorite].nil?
        @involved_property = InvolvedProperty.new(
          user: current_user, property: @property, favorite:params[:favorite], contacts: false)  
      end
      if @involved_property.save
        render json: @involved_property, status: :created
      else
        render json: @involved_property.errors, status: :unprocessable_entity
      end
    end
    
  end

  def update
    @property = Property.find(params[:property_id])
    involved_property = InvolvedProperty.where(user:current_user, property: @property)
    if !params[:contacts].nil?
      involved_property.update(involved_property_params)
    elsif !params[:favorite].nil?
      involved_property.update(involved_property_params)
      
      # involved_property.favorite = params[:favorite]
    end
    # involved_property.save
    render json: involved_property
  end

  def get_properties
    @user = current_user
    if (current_user.user_type === "landlord")
      active = Property.where(user_id: @user.id, status: true)
      closed = Property.where(user_id: @user.id, status: false)

      active_with_url = []
      closed_with_url = []
   
      active.each do |act|
        act_with_url = { property: act }
        if !act.images.attached?
          url = "sin imagen"
        else
          url = []
          i=0
          act.images.each do |_image|
            object = @s3.bucket("get-a-home").object(act.images[i].blob.key)
            i = i +1 
            url.push(object.presigned_url(:get, expires_in: 3600))
          end
          # object = @s3.bucket("get-a-home").object(act.images[0].blob.key)
          # url = object.presigned_url(:get, expires_in: 3600)
        end
        act_with_url[:url] = url
        active_with_url << act_with_url
      end

      closed.each do |clo|
        clo_with_url = { property: clo }
        if !clo.images.attached?
          url = "sin imagen"
        else
          url = []
          i=0
          clo.images.each do |_image|
            object = @s3.bucket("get-a-home").object(clo.images[i].blob.key)
            i = i +1 
            url.push(object.presigned_url(:get, expires_in: 3600))
          end
          # object = @s3.bucket("get-a-home").object(clo.images[0].blob.key)
          # url = object.presigned_url(:get, expires_in: 3600)
        end
        clo_with_url[:url] = url
        closed_with_url << clo_with_url
      end

      render json: { active: active_with_url, closed: closed_with_url}

    else
      render json: {error: "Please login as landlord to check your properties"}
    end

  end


  private

  def duplicate_involved_property
    render json: {error: "Actualiza la interacción, no crees una nueva"}
  end

  def involved_property_params
    params.require(:involved_property).permit(:contacts, :favorite, :property_id)
  end

  def set_s3_client
    @s3 = Aws::S3::Resource.new(region: "us-east-1",
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"] )
      # access_key_id: Rails.application.credentials[:aws][:access_key_id],
      # secret_access_key: Rails.application.credentials[:aws][:secret_access_key] )
  end


end