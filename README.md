# Agnet

2 Layer Feed forward Neural Network.

A little about the gem and neural networks.

1. It takes a csv file with an array of 784 bits. These represent a 28 x 28 = 784 pixel image of a hand drawn number from 0-9.

2. This array is sent through a neural network, which applies a function to the array which results in a 10 digit output array.

3. The function converts this 784 digit array into a 10 digit array containing most likely classification of the hand drawn image.
  - An image with a hand drawn 1, sent through this function would result in a output array like  
[0.01, 0.98, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]
  - However, as a learning machine, the function does not start out correctly classifying the images. It must learn from a labeled training set of these images.

4. I have set the gem to load 10,000 labeled training samples into the function when you call the training method and pass in a csv.

5. These samples get sent through the function and the result is compared to the label. The error between the result and label is then used to make automatic adjustments to the function. These adjustments accumulate and the function's accuracy in classifying a sample correctly rises. It will top out in the 80-95 range.


###Diagram of the Network

[![Mnist Neural Net](http://neuralnetworksanddeeplearning.com/images/tikz12.png)](http://neuralnetworksanddeeplearning.com/chap1.html)

###The algorithm behind the training function

[![AgNet Webm](http://i.imgur.com/MfTKqMv.gif)](https://zippy.gfycat.com/SparklingUnsightlyGopher.webm)
Click image for .webm/pausable version

Neural nets are cool because the technology around them have been responsible for big advances in AI over the past few years. From advancement in computer vision to the recent developments in computer Go playing, neural nets have been breaking some cool new barriers. Since the rudimentary idea is runnable on consumer computers, it can be fun for anyone to experiment with.

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
### Initialize your network
```ruby
  net = Agnet.new
```

### Train your Network with a csv file
```ruby
  net.train('path_to_your_csv_data_file')
```
Returns average of last 100 iterations during the training phase

(currently supports csv in format header label,pixel0,pixel1,...pixel783)

label from 0 to 9 (10 output nodes) 784 pixels (28x28 px image)

### Classify a potion of data with a test of your trained net
```ruby
  net.test
```
Returns average correct through test Float between 0 and 1

(the net.train(file) method is set to grab 10000 rows for training data and 2000 rows for test data)

### Classify an individual sample
```ruby
  net.classify([784 pixel array with values from 0-255])
```
Returns output activation array [10 values from 0.0 to 1.0]

### Training Scores
```ruby
  net.training_score
```
Returns array with scores and iterations and training score log

[iteration,training_score_log,total_running_average,running_average_100,running_average_1000,running_average_5000]

### Training Scores
```ruby
  net.testing_score
```
Returns array with scores and iterations and testing score log

[iteration,testing_score_log,total_running_average,running_average_100,running_average_1000,running_average_5000]

## Configuration

### Custom configuration in development and coming in future versions

Current Configuration

- input_nodes = 784
- hidden_nodes = 20
- output_nodes = 10
- hidden_function = 'sigmoid'
- output_function = 'soft_max'
- input_bias = 1.0
- hidden_bias = 1.0
- bits = 255.0
- learning_rate = 0.05
- training_size = 10000
- testing_size = 2000


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scsilver/agnet.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

##Attribution
Michael Nielsen's articles on [http://neuralnetworksanddeeplearning.com/](http://neuralnetworksanddeeplearning.com/) for network design reference and diagram
