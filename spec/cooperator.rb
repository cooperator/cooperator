require 'cooperator'

class Interactor
  prepend Cooperator
end

subject Cooperator

spec '#success? delegates to context.success?' do
  interactor = Interactor.new

  interactor.context.success!

  assert interactor, :success?

  interactor.context.failure!

  refute interactor, :success?
end
