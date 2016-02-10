require 'agnet'

net = Agnet.new(hidden_nodes: 20)
net.train('Examples/train.csv')
net.training_score
net.test
net.tetsting_score
