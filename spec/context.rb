require 'cooperator'

subject Cooperator::Context

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
