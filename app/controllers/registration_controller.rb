class RegistrationController < ApplicationController

  def register
    @registration_config = RegistrationConfig.find(params[:id])
    @record = record_class.new(params[:record])
    @page_history = (params[:page_history] || "").split("/")
    @page = @registration_config.pages.find{|p| p.name == @page_history.last}
    @problems = []
    if @page_history.empty?
      start_page
    elsif params[:commit] == "Next"
      @problems = check_constraints
      next_page unless @problems.size > 0
    else
      prev_page
    end
  end

  def start_page
    candidates = @registration_config.pages.select{|p| p.predecessors.empty?} 
    start = candidates.find{|p| p.exists?(@record)}
    while !start
      candidates = candidates.successors
      start = candidates.find{|p| p.exists?(@record)}
    end
    @page = start
    @page_history.push(@page.name)
  end

  def next_page
    @page = @page.successors.find{|s| s.exists?(@record)}
    @page_history.push(@page.name)
  end

  def prev_page
    @page_history.pop
    @page = @registration_config.pages.select{|p| p.name == @page_history.last}
  end

  private

  def check_constraints
    problems = []
    @page.constraints.each do |c|
      if !c.assert.check(@record)
        problems << c.message
      end
    end
    problems
  end

  def record_class
    tn = @registration_config.table_name
    Class.new(ActiveRecord::Base) do
      set_table_name tn
    end
  end

end
