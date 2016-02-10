require 'agnet'

net = Agnet.new
net.train('Examples/train.csv')
net.training_score
net.test
net.tetsting_score
