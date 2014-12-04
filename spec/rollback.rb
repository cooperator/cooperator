require 'cooperator'

class First
  prepend Cooperator

  def perform
  end

  def rollback
    $first = true
  end
end

class Second
  prepend Cooperator

  def perform
  end

  def rollback
    $second = true
  end
end

class Third
  prepend Cooperator

  def perform
    failure!
  end

  def rollback
    $third = true
  end
end

class Interactor
  prepend Cooperator

  def perform
    cooperate First, Second, Third
  end
end

prepare do
  $first = false
  $second = false
  $third = false
end

spec 'third rollback is not called when a failure is encountered' do
  Interactor.perform

  refute $third
end

spec 'second rollback is called when a failure is encountered' do
  Interactor.perform

  assert $second
end

spec 'first rollback is called when a failure is encountered' do
  Interactor.perform

  assert $first
end