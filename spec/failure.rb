require 'cooperator'

class Failure
  prepend Cooperator

  def perform
    $before = true
    failure!
    $after = true
  end
end

prepare do
  $before = false
  $after = false
end

subject Cooperator

spec '.perform runs until #failure! is called' do
  Failure.perform

  assert $before
  refute $after
end

spec '.perform returns a failure context' do
  context = Failure.perform

  assert context, :failure?
  refute context, :success?
end
