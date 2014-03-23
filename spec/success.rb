require 'cooperator'

class ImplicitSuccess
  prepend Cooperator

  def perform
    $before = true
    $after = true
  end
end

class ExplicitSuccess
  prepend Cooperator

  def perform
    $before = true
    success!
    $after = true
  end
end

prepare do
  $before = false
  $after = false
end

subject Cooperator

scope 'implicit success' do
  spec '.perform runs until #success! is called' do
    ImplicitSuccess.perform

    assert $before
    assert $after
  end

  spec '.perform returns a success context' do
    context = ImplicitSuccess.perform

    assert context, :success?
    refute context, :failure?
  end
end

scope 'explicit success' do
  spec '.perform runs until #success! is called' do
    ExplicitSuccess.perform

    assert $before
    refute $after
  end

  spec '.perform returns a success context' do
    context = ExplicitSuccess.perform

    assert context, :success?
    refute context, :failure?
  end
end
