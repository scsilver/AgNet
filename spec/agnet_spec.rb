require 'spec_helper'

describe Agnet do
  it 'has a version number' do
    expect(Agnet::VERSION).not_to be nil
  end

  describe 'public instance methods' do

    subject { Agnet.new(4, 16, 10) }

    let(:input) do
      [input_activation, weights_hidden, weights_output,
       input_nodes, hidden_nodes, output_nodes]
    end

    let(:output) { subject.process(input) }
    context 'responds to its methods' do
      it { expect(subject).to respond_to(:feed_forward) }
      it { expect(subject).to respond_to(:set_initial_weights) }
      it { expect(subject).to respond_to(:set_initial_factors) }
    end

    context 'executes methods correctly' do
      context '#set_initial_factorss' do
        it 'sets array of initial factors for hdn and output weight matrix' do
          expect(subject.set_initial_factors.size).to eq(2)
        end
        it 'sets array values according to function  1 / inputsize^0.5' do
          expect(subject.set_initial_factors[0]).to eq(0.5)
          expect(subject.set_initial_factors[1]).to eq(0.25)
        end
      end
      context '#set_initial_weights' do
        it 'sets initial hidden layer weight matrix' do
          expect(subject.set_initial_weights[0].column_count).to eq(5)
          expect(subject.set_initial_weights[0].row_count).to eq(16)
        end
        it 'sets initial output layer weight matrix' do
          expect(subject.set_initial_weights[1].column_count).to eq(17)
          expect(subject.set_initial_weights[1].row_count).to eq(10)
        end
        it 'sets initial hidden weight matrix values between 0.5 and -0.5' do
          expect(subject.set_initial_weights[0][0,0]).to be_within(0.5).of(0)
        end
        it 'sets initial output weight matrix values between 0.5 and -0.5' do
          expect(subject.set_initial_weights[1][0,0]).to be_within(0.5).of(0)
        end
      end
      context '#scale_initial_weights' do
        it 'mulitplys hidden initial factor to hidden weight matrix calcs' do
          init_weights = subject.set_initial_weights
          init_factors = subject.set_initial_factors
          expect(subject.scale_initial_weights[0][0,0]).to eq(init_weights[0][0,0]*init_factors[0])
        end
        it 'mulitplys output initial factor to ouput weight matrix calcs' do
          init_weights = subject.set_initial_weights
          init_factors = subject.set_initial_factors
          expect(subject.scale_initial_weights[1][0,0]).to eq(init_weights[1][0,0]*init_factors[1])
        end
      end
      context '#feed_forward' do
        it 'calcs weighted sum for each node in hdn layer with hdn weights' do
        end

        it 'activates each node in hidden layer' do
        end

        it 'cals weighted sum for each node in outpt layer with otpt weights' do
        end

        it 'activates each node in output layer' do
        end
      end
    end
  end
end
