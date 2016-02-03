# Agnet

2 Layer Feed forward Neural Network.

TODO:
1. Add more customization of neural net hyper-parameters
2. Mnist dataset example

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'agnet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install agnet

## Usage
1. Initialize your network
```ruby
  net = Agnet.new
```
2. Train your Network with a csv file
```ruby
  net.train('path_to_your_csv_data_file')
```
Returns average of last 100 iterations during the training phase
(currently supports csv in format header label,pixel0,pixel1,...pixel783)
label from 0 to 9 (10 output nodes) 784 pixels (28x28 px image)
3. Classify a potion of data with a test of your trained net
```ruby
  net.test
```
Returns average correct through test Float between 0 and 1
(the net.train(file) method is set to grab 10000 rows for training data and 2000 rows for test data)
4. Classify an individual sample
```ruby
  net.classify([784 pixel array with values from 0-255])
```
Returns output activation array [10 values from 0.0 to 1.0]
5. Training Scores
```ruby
  net.training_score
```
Returns array with scores and iterations and training score log
[iteration,training_score_log,total_running_average,running_average_100,running_average_1000,running_average_5000]
6. Training Scores
```ruby
  net.testing_score
```
Returns array with scores and iterations and testing score log
[iteration,testing_score_log,total_running_average,running_average_100,running_average_1000,running_average_5000]


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scsilver/agnet.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
