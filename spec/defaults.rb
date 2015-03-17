require 'cooperator'

class Action
  prepend Cooperator

  accepts :value, default: 1

  def perform
    $value = value
  end
end

prepare do
  $value = nil
end

spec '.accepts allows a default value' do 
  Action.perform
  
  assert $value, :==, 1
end
