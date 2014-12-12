require 'cooperator'

class Interactor
  prepend Cooperator

  def perform
    commit apple: 'Apple'
  end
end

scope '#commit' do
  spec 'set given properties to the current context' do
    context = Interactor.perform

    assert context.apple, :==, 'Apple'
  end
end

