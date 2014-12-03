require 'cooperator'

class Interactor
  prepend Cooperator

  needs :apple, :banana
  wants :coconut, :durian

  def perform
    value = apple
    value = banana
    value = coconut
    value = durian
  end
end

scope '.needs' do
  spec 'adds given properties to context requirements' do
    assert Interactor.requirements, :include?, :apple
    assert Interactor.requirements, :include?, :banana
  end

  spec 'delegate given properties to the current context' do
    interactor = Interactor.new apple: 'Apple', banana: 'Banana'

    assert interactor.apple, :==, 'Apple'
    assert interactor.banana, :==, 'Banana'
  end
end

scope '.wants' do
  spec 'does not add given properties to context requirements' do
    refute Interactor.requirements, :include?, :coconut
    refute Interactor.requirements, :include?, :durian
  end
end
