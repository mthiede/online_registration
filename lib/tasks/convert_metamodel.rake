require 'rgen/environment'
require 'rgen/serializer/json_serializer'
require 'concrete/metamodel/ecore_to_concrete'
require 'metamodel/event_registration_metamodel'

task :convert_metamodel do
  outfile = File.dirname(__FILE__)+"/../metamodel/generated/event_registration_metamodel.json"
  env = RGen::Environment.new

  trans = Concrete::Metamodel::ECoreToConcrete.new(nil, env, :featureFilter => lambda {|f| f.name != "predecessors"})
  trans.trans(EventRegistrationMetamodel.ecore.eAllClasses)

  File.open(outfile, "w") do |f|
    ser = RGen::Serializer::JsonSerializer.new(f, :leadingSeparator => false)
    ser.serialize(env.find(:class => Concrete::Metamodel::ConcreteMMM::Classifier))
  end

end
