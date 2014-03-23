require 'cooperator'

subject Cooperator::Context

spec '#success! marks the context as a success' do
  context = Cooperator::Context.new
  context.success!

  assert context, :success?
  refute context, :failure?
end
