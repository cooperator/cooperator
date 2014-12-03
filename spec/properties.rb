require 'cooperator'

class Interactor
  prepend Cooperator

  expects :apple, :banana
  wants :coconut, :durian

  gives :fig

  def perform
    value = apple
    value = banana
    value = coconut
    value = durian
  end
end

scope '.expects' do
  spec 'adds given properties to context requirements' do
    assert Interactor.expected, :include?, :apple
    assert Interactor.expected, :include?, :banana
  end

  spec 'delegate given properties to the current context' do
    interactor = Interactor.new apple: 'Apple', banana: 'Banana'

    assert interactor.apple, :==, 'Apple'
    assert interactor.banana, :==, 'Banana'
  end
end

scope '.wants' do
  spec 'does not add given properties to context requirements' do
    refute Interactor.expected, :include?, :coconut
    refute Interactor.expected, :include?, :durian
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
