require 'cooperator'

class First
  prepend Cooperator

  def perform
    context.first = 'first'
  end
end

class Second
  prepend Cooperator

  def perform
    context.second = 'second'
  end
end

class Success
  prepend Cooperator

  def perform
    cooperate First,
              Second
  end
end

scope 'no failure' do
  spec '#cooperate performs the given actions' do
    context = Success.perform

    assert context.first, :==, 'first'
    assert context.second, :==, 'second'
  end
end
