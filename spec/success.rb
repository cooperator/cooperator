require 'cooperator'

class Action
  prepend Cooperator

  def perform
    $before = true
    success!
    $after = true
  end
end

prepare do
  $before = false
  $after = false
end

subject Cooperator

spec '.perform runs until #success! is called' do
  Action.perform

  assert $before
  refute $after
end
