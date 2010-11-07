class RegistrationConfigsController < ApplicationController

  # GET /registration_configs
  # GET /registration_configs.xml
  def index
    @registration_configs = RegistrationConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registration_configs }
    end
  end

  # GET /registration_configs/1
  # GET /registration_configs/1.xml
  def show
    @registration_config = RegistrationConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registration_config }
    end
  end

  # GET /registration_configs/new
  # GET /registration_configs/new.xml
  def new
    @registration_config = RegistrationConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @registration_config }
    end
  end

  # GET /registration_configs/1/edit
  def edit
    @registration_config = RegistrationConfig.find(params[:id])
  end

  # POST /registration_configs
  # POST /registration_configs.xml
  def create
    @registration_config = RegistrationConfig.new(params[:registration_config])

    respond_to do |format|
      if @registration_config.save
        update_schema
        format.html { redirect_to(@registration_config, :notice => 'RegistrationConfig was successfully created.') }
        format.xml  { render :xml => @registration_config, :status => :created, :location => @registration_config }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /registration_configs/1
  # PUT /registration_configs/1.xml
  def update
    @registration_config = RegistrationConfig.find(params[:id])

    respond_to do |format|
      if @registration_config.update_attributes(params[:registration_config])
        update_schema
        format.html { redirect_to(@registration_config, :notice => 'RegistrationConfig was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_configs/1
  # DELETE /registration_configs/1.xml
  def destroy
    @registration_config = RegistrationConfig.find(params[:id])
    @registration_config.destroy
    drop_table

    respond_to do |format|
      format.html { redirect_to(registration_configs_url) }
      format.xml  { head :ok }
    end
  end

  private

  def drop_table
    tn = @registration_config.table_name
    ActiveRecord::Schema.define do
      drop_table(tn) if table_exists?(tn)
    end
  end

  def update_schema
    tn = @registration_config.table_name
    data = @registration_config.data_items 
    ActiveRecord::Schema.define do
      create_table(tn) unless table_exists?(tn) 
      cols = columns(tn)
      data.each do |d|
        col = cols.find{|c| c.name == d.name}
        if !col
          add_column(tn, d.name, d.type)
        elsif col.type != d.type
          change_column(tn, d.name, d.type)
        end
        cols.delete(col)
      end
      cols.each do |c|
        remove_column(tn, c.name)
      end 
    end
    Class.new(ActiveRecord::Base) do
      set_table_name tn 
    end
  end

end
