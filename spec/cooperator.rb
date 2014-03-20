require 'cooperator'

class Action
  prepend Cooperator

  def perform
    $performed = true
  end
end

prepare do
  $performed = false
end

subject Cooperator

spec '.perform runs the defined action' do
  Action.perform

  assert $performed
end
