require 'cooperator'

subject Cooperator::Context

spec 'dynamic setter and getter' do
  context = Cooperator::Context.new
  context.name = 'Apple'

  assert context.name, :==, 'Apple'
end

spec '.new accepts a hash' do
  context = Cooperator::Context.new name: 'Apple'

  assert context.name, :==, 'Apple'
end

spec '#errors is an array' do
  context = Cooperator::Context.new
  
  assert context.errors, :is_a?, Array
end

spec '#success! marks the context as a success' do
  context = Cooperator::Context.new
  context.success!

  assert context, :success?
  refute context, :failure?
end

spec '#failure! marks the context as a failure' do
  context = Cooperator::Context.new
  context.failure!

  assert context, :failure?
  refute context, :success?
end

spec '#include? returns true for an existing attribute' do
  context = Cooperator::Context.new name: 'Apple'

  assert context, :include?, :name
end

spec '#include? returns false for a non-existing attribute' do
  context = Cooperator::Context.new

  refute context, :include?, :name
end
