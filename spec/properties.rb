require 'cooperator'

class Interactor
  prepend Cooperator

  expects :apple, :banana
  accepts :coconut, :durian

  commits :fig

  def perform
    value = apple
    value = banana
    value = coconut
    value = durian
  end
end

scope '.expects' do
  spec 'adds given properties as expected/required input' do
    assert Interactor.expected, :include?, :apple
    assert Interactor.expected, :include?, :banana
  end

  spec 'delegate given properties to the current context' do
    interactor = Interactor.new apple: 'Apple', banana: 'Banana'

    assert interactor.apple, :==, 'Apple'
    assert interactor.banana, :==, 'Banana'
  end
end

scope '.accepts' do
  spec 'adds given properties as accepted/optional input' do
    assert Interactor.accepted, :include?, :coconut
    assert Interactor.accepted, :include?, :durian
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

scope '.commits' do
  spec 'adds given properties as committed/required output' do
    assert Interactor.committed, :include?, :fig
  end
end
