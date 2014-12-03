require 'cooperator'

class Interactor
  prepend Cooperator

  needs :apple, :banana
  wants :coconut, :durian

  gives :fig

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

  spec 'delegate given properties to the current context' do
    interactor = Interactor.new coconut: 'Coconut', durian: 'Durian'

    assert interactor.coconut, :==, 'Coconut'
    assert interactor.durian, :==, 'Durian'
  end

  spec 'return nil for properties not included in the current context' do
    interactor = Interactor.new

    assert interactor.coconut, :==, nil
    assert interactor.durian, :==, nil
  end
end
