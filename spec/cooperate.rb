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

class Third
  prepend Cooperator

  def perform
    context.third = 'third'
    failure!
  end
end

class Fourth
  prepend Cooperator

  def perform
    context.fourth = 'fourth'
  end
end

class Success
  prepend Cooperator

  def perform
    cooperate First,
              Second
  end
end

class Failure
  prepend Cooperator

  def perform
    cooperate First,
              Second,
              Third,
              Fourth
  end
end

subject Cooperator

scope 'no failure' do
  spec '#cooperate performs the given actions' do
    context = Success.perform

    assert context.first, :==, 'first'
    assert context.second, :==, 'second'
  end
end

scope 'has failure' do
  spec '#cooperate performs the given actions until a failure is met' do
    context = Failure.perform

    assert context.first, :==, 'first'
    assert context.second, :==, 'second'
    assert context.third, :==, 'third'
    refute context, :include?, :fourth
  end
end

