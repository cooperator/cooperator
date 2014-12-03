require 'cooperator'

class Interactor
  prepend Cooperator

  expects :input
  commits :output
end

scope '.perform' do
  spec 'raises an exception when an expected input is missing' do
    raises Exception do
      Interactor.perform
    end
  end

  spec 'raises an exception when a committed output is missing' do
    raises Exception do
      Interactor.perform
    end
  end
end
