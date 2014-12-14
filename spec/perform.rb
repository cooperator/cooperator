require 'cooperator'

class Expects
  prepend Cooperator

  expects :input

  def perform
  end
end

class CommitsWithoutCommit
  prepend Cooperator

  commits :output

  def perform
  end
end

class CommitsWithCommit
  prepend Cooperator

  commits :output

  def perform
    commit output: 'Output'
  end
end

scope '.perform' do
  spec 'raises an exception when an expected input is missing' do
    raises Exception do
      Expects.perform
    end
  end

  spec 'runs when an expected input exists' do
    Expects.perform input: 'Input'
  end

  spec 'raises an exception when a committed output is missing' do
    raises Exception do
      CommitsWithoutCommit.perform
    end
  end

  spec 'runs when a committed output exists' do
    CommitsWithCommit.perform
  end
end
