require 'cooperator'

class Action
  prepend Cooperator

  accepts :value, default: 1
  accepts :reference, default: -> { 1 }

  def perform
    $value = value
    $reference = reference
  end
end

prepare do
  $value = nil
  $reference = nil
end

spec '.accepts allows a default value' do 
  Action.perform

  assert $value, :==, 1
end

spec '.accepts allows a default lambda' do 
  Action.perform

  assert $reference, :==, 1
end
