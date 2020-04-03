// Copyright 2019 The TensorFlow Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
/// Stochastic gradient descent (SGD) optimizer.
///
/// An optimizer that implements stochastic gradient descent, with support for momentum, learning
/// rate decay, and Nesterov momentum.

public class SGD<Model: Differentiable>
  where Model.TangentVector: VectorProtocol & ElementaryFunctions,
  Model.TangentVector.VectorSpaceScalar == Double {
  public typealias Model = Model
  /// The learning rate.
  public var learningRate: Double
  /// The momentum factor. It accelerates stochastic gradient descent in the relevant direction
  /// and dampens oscillations.
  public var momentum: Double
  /// The weight decay.
  public var decay: Double
  /// Use Nesterov momentum if true.
  public var nesterov: Bool
  /// The velocity state of the model.
  public var velocity: Model.TangentVector = .zero
  /// The set of steps taken.
  public var step: Int = 0

  public init(
    for _: __shared Model,
    learningRate: Double = 0.01,
    momentum: Double = 0,
    decay: Double = 0,
    nesterov: Bool = false) {
    precondition(learningRate >= 0, "Learning rate must be non-negative")
    precondition(momentum >= 0, "Momentum must be non-negative")
    precondition(decay >= 0, "Weight decay must be non-negative")

    self.learningRate = learningRate
    self.momentum = momentum
    self.decay = decay
    self.nesterov = nesterov
  }

  public func update(_ model: inout Model, along direction: Model.TangentVector) {
    step += 1
    let learningRate = self.learningRate * 1 / (1 + decay * Double(step))
    velocity = velocity.scaled(by: momentum) - direction.scaled(by: learningRate)
    if nesterov {
      model.move(along: velocity.scaled(by: momentum) - direction.scaled(by: learningRate))
    } else {
      model.move(along: velocity)
    }
  }
}