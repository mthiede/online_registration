# TODO: remove the require if possible and do it the Rails way
require 'metamodel/event_registration_metamodel'
require 'metamodel/event_registration_metamodel_ext'

class RegistrationConfig < ActiveRecord::Base
  validates_presence_of :name
  validate :check_model

  def pages
    model_env.find(:class => EventRegistrationMetamodel::Page)
  end

  def data_items
    model_env.find(:class => EventRegistrationMetamodel::Data)
  end

  def table_name
    "record_#{id}"
  end

  private

  def check_model
    model_env.elements.collect{|e| check_element(e)}.flatten.each do |r|
      errors.add_to_base(r)
    end
    if pages.size < 1
      errors.add_to_base("Create at least one page (Page)")
    end
    if data_items.size < 1
      errors.add_to_base("Create at least one data item (Data)")
    end
    check_uniq_names(pages)
    check_uniq_names(data_items)
  end

  def check_element(e)
    errors = []
    _ename = e.class.ecore.name
    _ename += " '#{e.name}'" if e.respond_to?(:name) && !e.name.to_s.strip.empty?
    e.class.ecore.eAllStructuralFeatures.each do |f|
      fkind = f.is_a?(RGen::ECore::EAttribute) ? "attribute" : "reference"
      if f.many
        if e.getGeneric(f.name).size < f.lowerBound 
          errors << "Too few #{fkind}s '#{f.name}' for #{_ename}"
        end
        if f.upperBound > -1 && e.getGeneric(f.name).size > f.upperBound 
          errors << "Too many #{fkind}s '#{f.name}' for #{_ename}"
        end
      else
        if e.getGeneric(f.name).nil? && f.lowerBound > 0
          errors << "#{fkind.capitalize} '#{f.name}' of #{_ename} must not be empty"
        end
      end
      if f.is_a?(RGen::ECore::EReference)
        e.getGenericAsArray(f.name).each do |t| 
          if t.is_a?(RGen::MetamodelBuilder::MMProxy)
            errors << "Can not resolve reference '#{f.name}' to '#{t.targetIdentifier}' of #{_ename}"
          end
        end
      end
    end
    errors
  end

  def check_uniq_names(elements)
    by_name = {}
    elements.each do |e|
      if !e.name.strip.empty? && by_name[e.name]
        errors.add_to_base("Duplicate #{e.class.ecore.name} name '#{e.name}'")
      end
      by_name[e.name] = e
    end
  end

  def model_env
    return @model_env if @model_env
    @model_env = RGen::Environment.new
    inst = RGen::Instantiator::JsonInstantiator.new(@model_env, EventRegistrationMetamodel)
    inst.instantiate(config) if config && config.strip.size > 0
    @model_env
  end

end
