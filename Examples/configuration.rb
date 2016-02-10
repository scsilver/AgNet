require 'agnet'

net = Agnet.new(bits: 255, # dictated by data
                input_nodes: 784, # dictated by data
                hidden_nodes: 300, # the greater the number of nodes, the slower
                output_nodes: 10, # dictated by classes, 10 for 10 digits 0-9
                input_bias: 1.0, #hyperparameters
                hidden_bias: 1.0,
                hidden_layer_function: 'sigmoid', # choices between 'sigmoid'
                output_layer_function: 'soft_max', # and 'soft_max' currently
                learning_rate: 0.05
                )

net.train('Examples/train.csv', training_size: 1000, testing_size: 100)

net.training_score

net.test(test_first: 50) # only test first 50 in testing_data set

net.testing_score
