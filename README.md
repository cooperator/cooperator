[![Code Climate Score](http://img.shields.io/codeclimate/github/Erol/cooperator.svg?style=flat)](https://codeclimate.com/github/Erol/cooperator)

# Cooperator

Simple cooperative interactors for Ruby

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Erol/cooperator?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Inspired by the following:

* [LightService](https://github.com/adomokos/light-service) by [Atilla Domokos'](https://github.com/adomokos)
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
Cooperators are simple cooperative interactors for Ruby. Inspired by [LightService](https://github.com/adomokos/light-service) by [Atilla Domokos](https://github.com/adomokos) and [Interactor](https://github.com/collectiveidea/interactor) by [Collective Idea](https://github.com/collectiveidea), a cooperator is an object that does a single atomic task. Lightweight and simple, it does the job without the extra fuss.

### Context
A cooperator’s context consists of properties known to it at a given time. It can be passed by the calling method:

    context = CalculateCost.perform(amount: amount, quantity: quantity)
  
You can then access the passed parameters as part of the cooperator's context.

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
  
The added properties can also be accessed as part of the context even after execution.

    context = CalculateCost.perform(amount: amount, quantity: quantity)
    puts context.total

### Expects, Accepts, Commits

Several context properties may be optional or required for the execution of the cooperator. The cooperator, in return, may be expected too of a return value. To organize and validate their presence, Cooperator provides the ```expects```, ```accepts```, and ```commits``` directives.

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

Once execution has finished, if the committed output was not set, an exception is raised. Calling ```failure!```  would terminate execution, whether or not the committed output was set. Upon ```failure!```, no exception due to missing committed output will be raised.

#### Expected, Accepted, Committed
Designated expected, accepted, committed properties can be accessed through the ```expected```,  ```accepted```, and ```committed``` property.

    class CalculateTotal
      prepend Cooperator
    
      expects :amount
      expects :quantity
      
      accepts :discount
    
      commits :total
    
      def perform
        total = (amount * quantity)
        total -= (discount || 0)
        
        commit total: total
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


### Success and Failure of Context

#### Success!
Success is reached when the cooperator finishes execution without having any failures raised.

    def perform
      context.interest = context.amount * 0.02
    end

Success can also be explicitly reached by calling ```success!```

    def perform
      context.total = context.amount * context.quantity
      success!
      puts ‘Won’t be printed anymore.’
    end
  
```success!``` returns immediately to the calling method, ignoring the succeeding lines in the cooperator.

#### Failure!
To raise failure at any given point and stop further execution, call ```failure!```

    def perform
      if context.quantity < 0
        failure!
        puts “Won’t be printed anymore”
      end
    end

To check whether the cooperator have succeeded or failed, you can use ```success?``` or ```failure?```.

In ```CalculateCost#perform```:

    def perform
      success!
    end

In the call to the cooperator:

    context = CalculateCost.perfom(amount: amount, quantity: quantity)
    context.success? # true
    context.failure? # false




### Cooperate

One single task can be broken down into smaller subtasks. Several subtasks might need to be executed in chain, passing resulting values from one subtask to the next. Execution of succeeding subtasks might also depend on the successes of the previous. For these matters, Cooperator provides ```cooperate``` that accepts a list of cooperators that will be executed in sequence.

```cooperate``` passes its context to the cooperators it executes with the cooperators being able to change context properties along the way.
 
 	class CalculateTotal
    	prepend Cooperator
    
	    def perform
	      cooperate CalculateSubtotal,
	                ApplyDiscount
	    end
	end
 
 A failure in one cooperator passed to ```cooperate``` would stop execution of the chain, and thus succeeding cooperators would not be executed.
 
In ```CalculateSubtotal```:

	class CalculateSubtotal
    	prepend Cooperator

    	def perform
      		puts "Will be printed"
      		failure!
    	end
    end

In ```ApplyDiscount```:

	class ApplyDiscount
	  prepend Cooperator
	  
	  def perform
	    puts "Won't be printed"
	  end
	end

Calling ```CalculateTotal#perform```, would only output ```"Will be printed"```.

### Rollback
 
 During the course of execution of tasks in chain, several changes may have already been persisted (in the data store, object's state, etc), and most of the time, we want these changes undone if failure was raised somewhere during execution. We want to go back to the initial state, as if the action was not called.
  
 For this purpose, Cooperator provides ```rollback```.  On ```failure!```, all the rollback methods of the preceding cooperators in the ```cooperate``` chain will be called in reverse sequence.
 

	class ReserveProduct
		prepend Cooperator
		
		expects :product, :user
		expects :amount, :quantity
		
		def perform
			cooperate	DecreaseStocks,
						AddPayable
						SendReservationEmail
		end
	end
	
	class DecreaseStocks
		prepend Cooperator
		
		expects :product, :quantity
		
		def perform
			product.decrease_stocks! quantity
		end
		
		def rollback
			product.increase_stocks! quantity
			puts 'Executing rollback for DecreaseStocks'
		end
	end
	
	class AddPayable
		prepend Cooperator
		
		expects :user, :amount
		
		def perform
			user.payables.add amount
		end
		
		def rollback
			user.payables.deduct amount
			puts 'Executing rollback for AddPayable'
		end
	end
	
	class SendReservationEmail
		def perform
			failure!
		end
	end
	
Output:

	Executing rollback for AddPayable
	Executing rollback for DecreaseStocks
	
The rollback methods were called in reverse manner of how they are listed under ```cooperate```.
	
	

### Defaults
 Defaults stuff here



## Contributing

1. Fork it
2. Create your feature branch ( `git checkout -b my-new-feature` )
3. Create tests and make them pass ( `rake test` )
4. Commit your changes ( `git commit -am 'Added some feature'` )
5. Push to the branch ( `git push origin my-new-feature` )
6. Create a new Pull Request
