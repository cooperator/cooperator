require 'benchmark/ips'
require 'cooperator'

context = Cooperator::Context.new value: 1

Benchmark.ips do |bm|
  bm.report '#method_missing' do
    context.value
  end

  bm.report '#[]' do
    context[:value]
  end

  bm.compare!
end
