require 'cooperator'

class Interactor
  prepend Cooperator

  needs :apple, :banana

  def perform
    value = apple
    value = banana
  end
end

scope '.needs' do
  spec 'adds given properties to context requirements' do
    assert Interactor.requirements, :include?, :apple
    assert Interactor.requirements, :include?, :banana
  end
end
