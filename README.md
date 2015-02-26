[![Code Climate Score](http://img.shields.io/codeclimate/github/Erol/cooperator.svg?style=flat)](https://codeclimate.com/github/Erol/cooperator)

# Cooperator

Simple cooperative interactors for Ruby

Inspired by the following:

* [LightService](https://github.com/adomokos/light-service) by [Atilla Domokos](https://github.com/adomokos)
* [Interactor](https://github.com/collectiveidea/interactor) from [Collective Idea](https://github.com/collectiveidea)

## Installation

Add this line to your application's Gemfile:

    gem 'cooperator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cooperator

## Usage

### Cooperators
Cooperators are simple cooperative interactors for Ruby. Inspired by the [Interactor](https://github.com/collectiveidea/interactor) from [Collective Idea](https://github.com/collectiveidea), a cooperator is an object that does a single atomic task. Lightweight and simple, it does the job without the extra fuss.

### Context
A cooperator’s context consists of properties known to it at a given time. It can be passed by the calling method:

    context = CalculateCost.perform(amount: amount, quantity: quantity)
  
You can then access the passed paramerters as part of the cooperator's context.

    class CalculateCost
      prepend Cooperator
      
      def perform
        puts context.amount * context.quantity
      end
    end

Additional properties can also be added to the context during execution:

    class CalculateCost
      prepend Cooperator
      
      def perform
        context.total = context.amount * context.quantity
      end
    end
  
The added properties can then be accessed as part of the context even after execution.

    context = CalculateCost.perform(amount: amount, quantity: quantity)
    puts context.total


### Success and Failure of Context

#### Success!
Success is reached when the cooperator finishes execution without having raised failures.

    def perform
      context.interest = context.amount * 0.02
    end

Success can also be explicitly reached by calling ```success!```

    def perform
      context.total = context.amount * context.quantity
      success!
      puts ‘Won’t be printed anymore.’
    end
  
```success!``` returns immediately to the calling method, ignoring the succeeding lines in the cooperator. To explicitly reach success and still continue execution, use ```context.success!```.


    def perform
      context.total = context.amount * context.quantity
      context.success!
      puts ‘Will still be printed.’
    end


#### Failure!
To raise failure at any given point and stop further execution, call ```failure!```

    def perform
      if context.quantity < 0
        failure!
        puts “Won’t be printed anymore”
      end
    end

On the other hand, calling ```context.failure!``` would raise failure but would still continue further execution of the cooperator.

    def perform
      if context.quantity < 0
        context.failure!
        puts “Will still be printed”
      end
    end

To check whether the cooperator have succeeded or failed, use ```success?``` or ```failure?```.

In the ```perform``` method of cooperator CalculateCost:

    def perform
      success!
    end

In the call to cooperator:

    context = CalculateCost.perfom(amount: amount, quantity: quantity)
    context.success? #true
    context.failure? #false


### Expects, Accepts, Commits

Some parameters may be needed in the execution of certain tasks and are thus passed to cooperators which, after execution, may also have return values.

To organize and validate the presence of these parameters and return values, cooperator provides the ```expects```, ```accepts```, and ```commits``` directives.

#### Expects

Designates a given property as expected/required input

    class CalculateTotal
      prepend Cooperator
      
      expects :cost, :quantity
    
      def perform
      end
    end

In calling the cooperator, supply the expected properties of the context:
  
    CalculateTotal.perform(cost: cost, quantity: quantity)

Otherwise, an exception is raised if an expected input is not satisfied.

#### Accepts

Designates a given property as accepted but not required (optional) input

    accepts :discount

#### Commits

Designates a given property as a commited/required output

    commits :total

Once execution has finished, if the committed output was not set, an exception is raised. Calling ```failure!``` and ```context.failure!``` would terminate execution, whether or not the committed output was set. Upon failure, no exception due to missing committed output is raised.

#### Expected, Accepted, Committed
Designated expected, accepted, committed properties can be accessed through the ```expected```,  ```accepted```, and ```committed``` property.

    class CalculateTotal
      prepend Cooperator
    
      expects :amount, :quantity
      accepts :discount
    
      commits :total
    
      def perform
        context.total = ()context.amount * context.quantity)
        context.total -= (context.discount || 0)
      end
    end
  
    CalculateTotal.expected
    # [:amount, :quantity]
    
    CalculateTotal.accepted
    #  [:discount]
    
    CalculateTotal.committed
    # [:total]

    CalculateTotal.expected.include? :discount
    # false

### Cooperate
 Cooperate stuff here.


### Rollback
 Rollback stuff here


### Defaults
 Defaults stuff here

## Contributing

1. Fork it
2. Create your feature branch ( `git checkout -b my-new-feature` )
3. Create tests and make them pass ( `rake test` )
4. Commit your changes ( `git commit -am 'Added some feature'` )
5. Push to the branch ( `git push origin my-new-feature` )
6. Create a new Pull Request
