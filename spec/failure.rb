require 'cooperator'

class Action
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
  Action.perform

  assert $before
  refute $after
end
